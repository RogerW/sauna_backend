class SaunaGallery < ApplicationRecord
  belongs_to :sauna

  has_attached_file :photo,
                    styles: {
                      large: {
                        geometry: '1200x900#',
                        processors: [:watermark],
                        watermark_path: "#{Rails.root}/public/logo_main.png",
                        format: :png
                      },
                      large_webp: {
                        geometry: '1200x900#',
                        lossless: true,
                        format: :webp,
                        processors: [:watermark],
                        watermark_path: "#{Rails.root}/public/logo_main.png"
                      },
                      large_md: {
                        geometry: '640x480#',
                        processors: [:watermark],
                        watermark_path: "#{Rails.root}/public/logo_main_large_med.png",
                        format: :png
                      },
                      large__md_webp: {
                        geometry: '640x480#',
                        lossless: true,
                        format: :webp,
                        processors: [:watermark],
                        watermark_path: "#{Rails.root}/public/logo_main_large_med.png"
                      },
                      medium: {
                        geometry: '400x300#',
                        processors: [:watermark],
                        format: :png,
                        watermark_path: "#{Rails.root}/public/logo_main_medium.png"
                      },
                      medium_webp: {
                        geometry: '400x300#',
                        processors: [:watermark],
                        lossless: true, 
                        format: :webp,
                        watermark_path: "#{Rails.root}/public/logo_main_medium.png"
                      },
                      thumb: ['40x30#', :png],
                      thumb_webp: ['40x30#', :webp]
                    },
                    default_url: '/assets/:style/missing.:format'
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\z/
end
