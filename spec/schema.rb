ActiveRecord::Schema.define do
  self.verbose = false

  create_table :merchant_warrior_payment_requests do |t|
    t.text :ref
    t.text :credit_ref
    t.integer :transaction_id
    t.integer :repayment_id
    t.text :status
    t.timestamps
  end

end
