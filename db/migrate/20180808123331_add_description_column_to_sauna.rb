class AddDescriptionColumnToSauna < ActiveRecord::Migration[5.1]
  def up
    add_column :saunas, :description, :string

    execute "UPDATE saunas SET description = sauna_descriptions.description FROM sauna_descriptions WHERE saunas.id = sauna_descriptions.sauna_id"
  end

  def down
    remove_column :saunas, :description, :string

    execute "UPDATE sauna_descriptions SET description = sauna_descriptions.description FROM saunas WHERE saunas.id = sauna_descriptions.sauna_id"
  end
end
