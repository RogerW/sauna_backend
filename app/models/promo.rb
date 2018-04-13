class Promo < ApplicationRecord
  has_attached_file :image,
                    styles: {
                      main: {
                        geometry: '400x300#',
                        processors: [:watermark],
                        watermark_path: "#{Rails.root}/public/logo_main_medium.png"
                      },
                      thumb: ['40x30#', :webp]
                    },
                    default_url: '/assets/:style/missing.png'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  validates_presence_of :user_id, :sauna_id, :title, :desc, :active_range

  after_initialize :set_default_state, if: :new_record?

  belongs_to :sauna
  belongs_to :user

  def set_default_state
    self.status ||= 0
  end
end
