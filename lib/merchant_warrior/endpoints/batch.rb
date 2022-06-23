# platform = Platform.find(40)
# loan = platform.track_loans.active.last


# batch =  Track::RepaymentBatch.where(platform_id: platform.id).last
# service = MerchantWarrior::BatchService.new(platform)
# service.send_batch_as_csv(batch)

# batch =  Track::RepaymentBatch.where(platform_id: 40).last(1).first
# service.retrieve_batch_csv(batch)

module Endpoints
  module Batch
    def process_batch(api_key, api_passphrase, merchant_uuid, batch_file)
      # return process_batch_test_response if !Rails.env.production?
      url = URI("https://base.merchantwarrior.com/post/")
      notify_url = "https://a471-110-174-140-59.ngrok.io/services/merchant_warrior/process_batch"
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      request = Net::HTTP::Post.new(url)
      form_data = [
        ['method', 'processBatch'],
        ['batchFile', File.open(batch_file.zipfile)],
        ['merchantUUID', merchant_uuid],
        ['apiKey', api_key],
        ['batchNotifyURL', notify_url],
        ['fileHash', Digest::MD5.hexdigest(File.read(batch_file.zipfile))],
        ['urlHash', url_hash(api_passphrase, merchant_uuid, notify_url)]
      ]

      request.set_form form_data, 'multipart/form-data'
      response = https.request(request)
      Hash.from_xml(response.read_body).deep_symbolize_keys
    end

    def retrieve_batch(api_key, merchant_uuid, batch_uuid)
      # return retrieve_batch_test_response if !Rails.env.production?
      body = {
        method: "retrieveBatch",
        merchantUUID: merchant_uuid,
        apiKey: api_key,
        batchUUID: batch_uuid,
        hash: response_hash(api_passphrase, merchant_uuid, batch_uuid)
      }
      response = post(body)
      response.parsed_response
    end

    def url_hash(api_passphrase, merchant_uuid, notify_url)
      binding.pry
      hash = (Digest::MD5.hexdigest(api_passphrase) + merchant_uuid + notify_url).downcase
      hash = Digest::MD5.hexdigest(hash)
    end

    def file_hash(file)
      Digest::MD5.hexdigest(file)
    end

    def response_hash(api_passphrase, merchant_uuid, batch_uuid)
      Digest::MD5.hexdigest(
        (
          api_passphrase +
          merchant_uuid +
          batch_uuid
        ).downcase
      )
    end

    def process_batch_test_response
      {
        "responseCode": "0",
        "responseMessage": "Batch has been successfully submitted.",
        "batchUUID": "1336583d3a953ce2d"
      }
    end

  end
end