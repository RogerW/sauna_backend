class SaunaList < ApplicationRecord
  has_attached_file :logotype,
  styles: {
    large: '1200x900>',
    medium: '400x300>',
    thumb: ['40x30>', :webp]
  },
  default_url: '/assets/:style/missing.png'
end