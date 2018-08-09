class UpdateSaunaListsToVersion7 < ActiveRecord::Migration[5.0]
  def change
    update_view :sauna_lists, version: 7, revert_to_version: 6
  end
end
