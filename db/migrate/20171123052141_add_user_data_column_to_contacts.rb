class AddUserDataColumnToContacts < ActiveRecord::Migration[5.1]
  def change
    add_reference :contacts, :contactable, polymorphic: true, index: true
  end
end
