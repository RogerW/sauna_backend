class CreateUsersSaunas < ActiveRecord::Migration[5.1]
  def change
    create_table :users_saunas, id: false do |t|
      t.bigint :user_id, null:false
      t.belongs_to :sauna, foreign_key: true
    end
  end
end
