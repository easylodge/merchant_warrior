module Endpoints
  module DirectDebit
    def process_ddebit(api_key, api_passphrase, merchant_uuid, details = {})
      unless Rails.env.production?
        details[:customer_name] = "Test Customer"
        details[:address] = "123 Test street"
        details[:phone] = "0404040404"
        details[:email] = "Test@testemail.com"
        details[:bsb_number] = "123456"
        details[:account_number] = "12345678"
        details[:account_name] = "Test person"
        details[:postcode] = "4000"
        details[:state] = "QLD"
      end

      return process_debit_test_response if !Rails.env.production?
      body = {
        method: "processDDebit",
        merchantUUID: merchant_uuid,
        apiKey: api_key,
        transactionAmount: details[:amount],
        transactionCurrency: "AUD",
        transactionProduct: 100001,
        customerName: details[:customer_name],
        customerCountry: "AU",
        customerState: details[:state],
        customerCity: "Brisbane",
        customerAddress: details[:address], #"123 Test Street",
        customerPostCode: details[:postcode],
        customerPhone: details[:phone],
        customerEmail: details[:email], #optional - recommended
        customerIP: "", #optional - recommended
        paymentAccountBSB: details[:bsb_number]&.tr('^0-9', ''),
        paymentAccountNumber: details[:account_number]&.tr('^0-9', ''),
        paymentAccountName: details[:account_name],
        hash: transaction_hash(api_passphrase, merchant_uuid, details[:amount]),
        custom1: details[:custom1],
        custom2: details[:custom2],
        custom3: details[:custom3]
      }
      return process_debit_test_response if !Rails.env.production?
      post(body).parsed_response.deep_symbolize_keys
    end

    def query_ddebit(api_key, api_passphrase, merchant_uuid, mw_ddebit_request_id)
      return query_dd_test_response if !Rails.env.production?
      body = {
        method: 'queryDD',
        merchantUUID: merchant_uuid,
        apiKey: api_key,
        transactionID: mw_ddebit_request_id,
        hash: query_hash(api_passphrase, merchant_uuid, mw_ddebit_request_id )
      }

      post(body).parsed_response.deep_symbolize_keys
    end

    private

    def transaction_hash(api_passphrase, merchant_uuid, amount)
      Digest::MD5.hexdigest(
        (
          api_passphrase +
          merchant_uuid +
          amount.to_s +
          "AUD"
        ).downcase
      )
    end


    def query_hash(api_passphrase, merchant_uuid, mw_ddebit_request_id)
      hash = (Digest::MD5.hexdigest(api_key) + merchant_uuid + mw_ddebit_request_id).downcase
      Digest::MD5.hexdigest(hash)
    end

    def process_debit_test_response
      {
        :mwResponse=>
        {
          :responseCode=>"10",
          :responseMessage=>"Transaction pending",
          :transactionID=>"22014-8382e1d1-e60d-11ec-a43d-005056b2764e",
          :transactionReferenceID=>nil,
          :settlementDate=>"2022-06-10",
          :custom1=>"972466",
          :custom2=>nil,
          :custom3=>nil,
          :customHash=>"10a6cca986a5c314e6cd11202362f87d"}
        }
    end

    def query_dd_test_response
      {
        responseCode: "10",
        responseMessage: "Transaction pending",
        transactionID: "1336-d2b4ccfc-b612-11e6-b9c3-005056b209e0",
        settlementDate: [],
        custom1: [],
        custom2: [],
        custom3: [],
        customHash: "9e71fc2a99a71b722ead746b776b25ac"
      }
    end

  end
end