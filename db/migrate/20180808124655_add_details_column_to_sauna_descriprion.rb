class AddDetailsColumnToSaunaDescriprion < ActiveRecord::Migration[5.1]
  def change
    add_column :sauna_descriptions, :details, :jsonb
  end
end
