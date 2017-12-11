class RenameTypeToInvTypeColumnFromInvoices < ActiveRecord::Migration[5.1]
  def change
    rename_column :invoices, :type, :inv_type
  end
end
