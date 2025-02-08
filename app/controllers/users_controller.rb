class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user, only: [:edit]
  before_action :ensure_correct_user, only: [:update, :edit]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    
    # 相互フォローチャットルーム作成
    @currentUserEntry=Entry.where(user_id: current_user.id)
    @userEntry=Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def index
    @users = User.all
    @book = Book.new
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @obj = @user  #エラー表示用
    if @user.update(user_params)
      flash[:notice] =  "You have updated user successfully."
      redirect_to users_path
    else
      render template: "users/edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
 
  # 与えられたIDを持つユーザーを検索し、そのユーザーが現在のユーザーであるかを確認
  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
  
  # ゲストユーザーはプロフィール編集画面へ遷移できない
  # "guest_user"はモデルで設定（ゲストユーザー判定）
  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.guest_user?
       flash[:alert] = "ゲストユーザーはプロフィール編集画面へ遷移できません。"
      redirect_to user_path(current_user)
    end
  end  

end
