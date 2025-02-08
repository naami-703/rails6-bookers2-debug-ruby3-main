class BooksController < ApplicationController
  before_action :authenticate_user!
  #before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  
  def show
    @book = Book.find(params[:id])
    current_user.read_counts.create(book_id: @book.id)
    @book_new = Book.new
    @user = @book.user
    @user_image =  @user.get_user_image(100, 100)
    @book_comment = BookComment.new
  end

  def index
    @user = current_user
    
    # 投稿一覧を新着順・いいねの多い順に並び替え
    if params[:latest]
      @books = Book.latest
    elsif params[:favorites]
      #to = Time.current.at_end_of_day
      #from = (to - 6.day).at_beginning_of_day
      @books = Book.includes(:favorites).sort_by { |book| -book.favorites.count }
    else
      @books = Book.all
    end
    
    @book = Book.new
    @obj = @book #エラー表示用
  end

  def create
    @book = Book.new(book_params)
    @obj = @book #エラー表示用
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    @obj = @book #エラー表示用
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :category)
  end
 
  # 与えられたIDを持つ本（Book）を検索し、その本が現在のユーザーによって所有されているかを確認
  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end


end
