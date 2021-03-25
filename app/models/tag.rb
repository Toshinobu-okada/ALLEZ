class Tag < ApplicationRecord
  has_many :tagmaps, dependent: :destroy
  has_many :post_image, through: :tagmaps
end
