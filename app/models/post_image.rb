class PostImage < ApplicationRecord

  belongs_to :user
  attachment :image
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :tagmaps, dependent: :destroy
  has_many :tags, through: :tagmaps

  validates :title, presence: true
  validates :image, presence: true

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def save_posts(savepost_tags)
    current_tags = self.tags.pluck(:tag_name) unless self.tags.nil?
    old_tags = current_tags - savepost_tags
    new_tags = savepost_tags - current_tags

    # Destroy old taggings:
    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(tag_name:old_name)
    end

    # Create new taggings:
    new_tags.each do |new_name|
      post_tag = Tag.find_or_create_by(tag_name:new_name)
      self.tags << post_tag
    end
  end

  scope :search, -> (search) { joins(:user).where("OR users.name LIKE ?post_images.title LIKE ?  OR post_images.share_comment LIKE ? OR tags.tag_name LIKE", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%" ) }

end
