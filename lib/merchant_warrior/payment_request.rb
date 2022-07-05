require "active_record"

class MerchantWarrior::PaymentRequest < ActiveRecord::Base
  self.table_name = "merchant_warrior_payment_requests"
  validates :status, presence: true
end
