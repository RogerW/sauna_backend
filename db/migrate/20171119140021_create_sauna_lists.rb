class CreateSaunaLists < ActiveRecord::Migration[5.0]
  def change
    create_view :sauna_lists
  end
end
