class RemoveUserFromContacts < ActiveRecord::Migration[5.1]
  def change
    remove_column :contacts, :user_id, :bigint
  end
end
