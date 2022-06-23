require "active_record"

class MerchantWarrior::PaymentRequest < ActiveRecord::Base
  self.table_name = "merchant_warrior_payment_requests"

  # validates :repayment_id, presence: true
  # validates :mw_transaction_id, presence: true
  # validates :transaction_reference, presence: true
  # validates :response_message, presence: true
  # validates :custom_hash, presence: true
  # validates :status, presence: true
  # validates :provider_response, presence: true

  def self.format_status(provider_response)
    case provider_response
    when "Transaction pending" then "pending"
    end
  end

end
