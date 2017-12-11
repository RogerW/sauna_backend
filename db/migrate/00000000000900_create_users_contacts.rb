class CreateUsersContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :users_contacts, id: false do |t|
      t.bigint :user_id, null: false
      t.belongs_to :contact, foreign_key: true
    end
  end
end
