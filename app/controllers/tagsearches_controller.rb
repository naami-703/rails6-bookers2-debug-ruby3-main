class  TagsearchesController < ApplicationController

  def search
    @model = Book
    @word = params[:content] #検索フォームで「content」指定
    @book_comments = BookComment.new
    @books = Book.where("category LIKE ?", "%#{@word}%")
    render "tagsearches/tagsearch"
  end

#モデルクラス.where("列名 LIKE ?", "%値%")  # 値(文字列)を含む
#モデルクラス.where("列名 LIKE ?", "値_")   # 値(文字列)と末尾の1文字

end

