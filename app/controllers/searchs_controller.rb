class SearchsController < ApplicationController
  # ユーザーのログイン判定
  before_action :authenticate_user!

  def search
    # 検索モデル→params[:range]
    @range = params[:range] 
    @word = params[:word]

    if @range == "User"
      # 検索方法→params[:search]、検索ワード→params[:word]
      # looksメソッドを使い、検索内容を取得し、変数に代入
      # @usersにUserモデル内での検索結果を代入。！
      @users = User.looks(params[:search], params[:word])
    else
      # @booksにBookモデル内での検索結果を代入。
      @books = Book.looks(params[:search], params[:word])
    end
  end

end
