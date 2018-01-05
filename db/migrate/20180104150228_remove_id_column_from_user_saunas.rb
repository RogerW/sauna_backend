class RemoveIdColumnFromUserSaunas < ActiveRecord::Migration[5.1]
  def change
    remove_column :users_saunas, :id, :bigint
  end
end
