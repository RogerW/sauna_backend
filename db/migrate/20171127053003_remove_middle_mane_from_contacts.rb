class RemoveMiddleManeFromContacts < ActiveRecord::Migration[5.1]
  def change
    remove_column :contacts, :middle_mane, :string
  end
end
