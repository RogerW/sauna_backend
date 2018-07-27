class AddIndexToContact < ActiveRecord::Migration[5.1]
  def change
    add_index :contacts, %i[phone contactable_type contactable_id], unique: true
  end
end
