class AddAasmStateColumnToInvoices < ActiveRecord::Migration[5.1]
  def change
    add_column :invoices, :aasm_state, :string
  end
end
