module Endpoints
  module Batch
    def process_batch(api_key, api_passphrase, merchant_uuid, batch_file)
      url = URI("https://base.merchantwarrior.com/post/")
      notify_url = "www.easylodge.com.au/services/merchant_warrior/process_batch"
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