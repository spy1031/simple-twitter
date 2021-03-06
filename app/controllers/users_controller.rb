class UsersController < ApplicationController
  before_action :set_user, only: [:tweets,:followings,:followers,:edit,:update,:likes]
  def tweets
    @user = User.find(params[:id])
    @tweets = @user.tweets
  end

  def edit
    if current_user != @user

     
      redirect_to tweets_user_path(@user)
    end
  end

  def update
    if @user.update(user_params)
      redirect_to tweets_user_path
      flash[:notice] = "User profile was successfully updated"
    else
      
      flash[:alert] = @user.errors.full_messages.to_sentence
      render :edit
    end
  end

  def followings
    @followships = @user.followships.order(created_at: :desc)
    @followings = Array.new# 基於測試規格，必須講定變數名稱
    @followships.each do |followship|
      @followings << User.find(followship.following_id)
    end
  end

  def followers
    @followships = @user.inverse_followships.order(created_at: :desc)
    @followers = Array.new # 基於測試規格，必須講定變數名稱
    @followships.each do |followship|
      @followers << User.find(followship.user_id)
    end
  end

  def likes

    @likes = @user.likes.order(created_at: :desc)# 基於測試規格，必須講定變數名稱
    @liked_tweets = Array.new
    @likes.each do |like|
      @liked_tweets << Tweet.find(like.tweet_id)
    end
   @likes = @liked_tweets
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :avatar)
  end


  def set_user
    @user = User.find(params[:id])
  end
end
