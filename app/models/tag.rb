class Tag < ApplicationRecord
  has_many :tagmaps, dependent: :destroy
  has_many :post_image, through: :tagmaps

  def hash_tag
    '#'+self.tag_name
  end
end
