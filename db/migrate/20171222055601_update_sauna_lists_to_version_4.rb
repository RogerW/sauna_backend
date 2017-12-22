class UpdateSaunaListsToVersion4 < ActiveRecord::Migration[5.0]
  def change
    update_view :sauna_lists, version: 4, revert_to_version: 3
  end
end
