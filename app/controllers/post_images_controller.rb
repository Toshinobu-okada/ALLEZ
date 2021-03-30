class PostImagesController < ApplicationController
  before_action :authenticate_user!,except: [:index, :show, :search]

  def new
    @post_image = PostImage.new
  end

  def create
    @post_image = PostImage.new(post_image_params)
    @post_image.user_id = current_user.id
    tag_list = params[:post_image][:tag_name].scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    tag_list = tag_list.map{ |tag| tag.downcase.delete('#')}

    if @post_image.save
      @post_image.save_posts(tag_list)
      redirect_to post_images_path
    else
      render :new
    end

  end

  def index
    @post_images = PostImage.page(params[:page]).per(12).reverse_order
  end

  def show
    @post_image = PostImage.find(params[:id])
    @post_comment = PostComment.new
  end

  def destroy
    @post_image = PostImage.find(params[:id])
    @post_image.destroy
    redirect_to post_images_path
  end

  def search
    if params[:search] && params[:search].index("#") == 0
      @searched_post_images = PostImage.search_tag(params[:search]).page(params[:page]).per(12)
    else
      @searched_post_images = PostImage.search(params[:search]).page(params[:page]).per(12)
    end
    @post_image_order_by_created = @searched_post_images.order(created_at: "desc").page(params[:page]).per(12)
    @post_image_order_by_like_count = @searched_post_images.order(likes_count: "desc").page(params[:page]).per(12)
  end

   private

  def post_image_params
    params.require(:post_image).permit(:title, :image, :share_comment)
  end

end
