require "httparty"
require 'net/http'
require 'uri'
require 'pry'

require "merchant_warrior/endpoints/batch"
require "merchant_warrior/endpoints/direct_debit"

module MerchantWarrior
  class Api
    include Endpoints::Batch
    include Endpoints::DirectDebit
    attr_accessor :api_key, :api_passphrase, :merchant_uuid, :base_url

    def initialize(api_key, api_passphrase, merchant_uuid)
      @api_key = api_key
      @api_passphrase = api_passphrase
      @merchant_uuid = merchant_uuid
      @base_url = "https://base.merchantwarrior.com/post/"
      # @base_url = Rails.env.production? ?  "https://api.merchantwarrior.com/post/" : "https://base.merchantwarrior.com/post/"
    end

    # def process_ddebit
    #   # headers = build_ddebit_headers
    # end

    private

    def http
      @http ||= HTTParty
    end

    def headers
      @headers ||= { "Authorization": "Bearer #{@api_key}"}
    end

    def get(endpoint)
      HTTParty.get(@base_url + endpoint, headers: headers)
    rescue
      { errors: "Failed to connect to Merchant Warrior" }
    end

    def patch(endpoint, body)
      HTTParty.patch(@base_url + endpoint, headers: headers, body: body)
    rescue
      { errors: "Failed to connect to Merchant Warrior" }
    end

    # < 0	MW validation error
    # = 0	Transaction/Operation was successful
    # > 0	Transaction/Operation was declined or delayed by the provider or service
    def post(body)
      HTTParty.post(@base_url, body: body)
    rescue
      { errors: "Failed to connect to Merchant Warrior" }
    end

    def delete(endpoint, body)
      HTTParty.post(@base_url + endpoint, headers: headers)
    rescue
      { errors: "Failed to connect to Merchant Warrior" }
    end

  end
end