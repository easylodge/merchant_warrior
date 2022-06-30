require "active_record"

class MerchantWarrior::PaymentRequest < ActiveRecord::Base
  self.table_name = "merchant_warrior_payment_requests"
  validates :mw_transaction_id, presence: true
  validates :repayment_id, presence: true
  validates :status, presence: true

  def self.format_status(provider_response)
    case provider_response
    when "Transaction pending" then "pending"
    end
  end

end
