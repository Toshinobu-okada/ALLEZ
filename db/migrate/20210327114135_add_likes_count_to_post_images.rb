class AddLikesCountToPostImages < ActiveRecord::Migration[5.2]
  def change
    add_column :post_images, :likes_count, :integer
  end
end
