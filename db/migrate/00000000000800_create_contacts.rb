class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :middle_mane
      t.string :last_name
      t.string :phone
      t.bigint :user_id, null:false

      t.timestamps
    end
  end
end
