class AddMiddleNameColumnToContact < ActiveRecord::Migration[5.1]
  def change
    add_column :contacts, :middle_name, :string
  end
end
