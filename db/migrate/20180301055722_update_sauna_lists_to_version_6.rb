class UpdateSaunaListsToVersion6 < ActiveRecord::Migration[5.0]
  def change
    update_view :sauna_lists, version: 6, revert_to_version: 5
  end
end
