class RemovePhotoColumnFromSaunaGalleries < ActiveRecord::Migration[5.1]
  def change
    remove_column  :sauna_galleries, :photo, :string
    add_attachment :sauna_galleries, :photo
  end
end
