class CreateMerchantWarriorPaymentRequest < ActiveRecord::Migration
  def self.up
    unless ActiveRecord::Base.connection.table_exists? 'create_merchant_warrior_payment_request'
      create_table :create_merchant_warrior_payment_request do |t|
        t.string :payment_reference
        t.integer :repayment_id
        t.string :status
        t.timestamps
      end

    end
  end

  def self.down
    drop_table :create_merchant_warrior_payment_request if ActiveRecord::Base.connection.table_exists? 'create_merchant_warrior_payment_request'
  end
end
