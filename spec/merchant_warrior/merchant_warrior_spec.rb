require 'spec_helper'

describe MerchantWarrior::Api do
  let(:subject) { MerchantWarrior::Api.new }

  xdescribe "#get" do
    it "" do
      @response = JSON.parse(File.read('spec/responses.json'))
    end
  end

  xdescribe "#patch" do
    it "" do
      @response = JSON.parse(File.read('spec/responses.json'))
    end
  end

  xdescribe "#post" do
    it "" do
      @response = JSON.parse(File.read('spec/responses.json'))
    end
  end

  xdescribe "#delete" do
    it "" do
      @response = JSON.parse(File.read('spec/responses.json'))
    end
  end

end
