class AddLogoColumnsToSaunas < ActiveRecord::Migration[5.1]
  def change
    add_attachment :saunas, :logotype
  end
end
