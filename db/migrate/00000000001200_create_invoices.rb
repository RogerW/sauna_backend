class CreateInvoices < ActiveRecord::Migration[5.1]
  def change
    create_table :invoices do |t|
      t.belongs_to :sauna, foreign_key: true
      t.bigint :user_id, null: false
      t.integer :type
      t.integer :state
      t.monetize :amount
      t.decimal :discount, precision: 4, scale: 2
      t.monetize :result

      t.timestamps
    end
  end
end
