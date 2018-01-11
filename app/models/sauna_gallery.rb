class SaunaGallery < ApplicationRecord
  belongs_to :sauna

  has_attached_file :photo,
                    styles: {
                      large: '1200x900#',
                      medium: '400x300#',
                      thumb: ['40x30#', :webp]
                    },
                    default_url: '/assets/:style/missing.png'
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\z/
end
