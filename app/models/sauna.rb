class Sauna < ApplicationRecord
  # has_one_attached :logotype

  has_attached_file :logotype,
                    styles: {
                      large: {
                        geometry: '1200x900#',
                        processors: [:watermark],
                        watermark_path: "#{Rails.root}/public/logo_main.png",
                        format: :png,
                        default_url: '/assets/:style/missing.png'
                      },
                      large_webp: {
                        geometry: '1200x900#',
                        lossless: true,
                        format: :webp,
                        processors: [:watermark],
                        watermark_path: "#{Rails.root}/public/logo_main.png",
                        default_url: '/assets/:style/missing.webp'
                      },
                      large_md: {
                        geometry: '640x480#',
                        processors: [:watermark],
                        watermark_path: "#{Rails.root}/public/logo_main_large_med.png",
                        format: :png,
                        default_url: '/assets/:style/missing.png'
                      },
                      large__md_webp: {
                        geometry: '640x480#',
                        lossless: true,
                        format: :webp,
                        processors: [:watermark],
                        watermark_path: "#{Rails.root}/public/logo_main_large_med.png",
                        default_url: '/assets/:style/missing.webp'
                      },
                      medium: {
                        geometry: '400x300#',
                        processors: [:watermark],
                        format: :png,
                        watermark_path: "#{Rails.root}/public/logo_main_medium.png",
                        default_url: '/assets/:style/missing.png'
                      },
                      medium_webp: {
                        geometry: '400x300#',
                        processors: [:watermark],
                        lossless: true,
                        format: :webp,
                        watermark_path: "#{Rails.root}/public/logo_main_medium.png",
                        default_url: '/assets/:style/missing.webp'
                      },
                      thumb: ['40x30#', :png],
                      thumb_webp: ['40x30#', :webp]
                    },
                    default_url: '/assets/:style/missing.png'
  validates_attachment_content_type :logotype, content_type: %r{\Aimage\/.*\z}

  has_many :promos
  has_many :reservations
  has_many :billings
  has_many :sauna_galleries
  has_one :sauna_description

  accepts_nested_attributes_for :billings, reject_if: proc { |attributes| attributes[:start_time, :end_time, :cost].blank? }, allow_destroy: true
  accepts_nested_attributes_for :sauna_description, reject_if: proc { |attributes| attributes[:description].blank? }, allow_destroy: true

  has_many :contacts, as: :contactable

  has_and_belongs_to_many :users, join_table: 'users_saunas', foreign_key: 'sauna_id'
end
