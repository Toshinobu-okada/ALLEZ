class Favorite < ApplicationRecord

  belongs_to :user
  belongs_to :post_image
  counter_culture :post_image, column_name: "likes_count"
  validates :user_id, presence: true
  validates :post_image_id, presence: true

end
