class SaunaGallery < ApplicationRecord
  belongs_to :sauna

  has_attached_file :photo,
                    styles: {
                      large: {
                        geometry: '1200x900#',
                        processors: [:watermark],
                        watermark_path: "#{Rails.root}/public/logo_main.png"
                      },
                      medium: {
                        geometry: '400x300#',
                        processors: [:watermark],
                        watermark_path: "#{Rails.root}/public/logo_main_medium.png"
                      },
                      thumb: ['40x30#', :webp]
                    },
                    default_url: '/assets/:style/missing.png'
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\z/
end
