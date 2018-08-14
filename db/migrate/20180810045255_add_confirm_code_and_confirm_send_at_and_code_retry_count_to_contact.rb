class AddConfirmCodeAndConfirmSendAtAndCodeRetryCountToContact < ActiveRecord::Migration[5.1]
  def change
    add_column :contacts, :confirm_code, :string
    add_column :contacts, :confirm_send_at, :datetime
    add_column :contacts, :confirmed_at, :datetime
    add_column :contacts, :code_retry_count, :integer, default: 0
    add_column :contacts, :code_send_count, :integer, default: 0
  end
end
