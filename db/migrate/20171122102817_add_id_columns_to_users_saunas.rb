class AddIdColumnsToUsersSaunas < ActiveRecord::Migration[5.1]
  def change
    add_column :users_saunas, :id, :primary_key
  end
end
