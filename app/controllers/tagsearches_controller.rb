class  TagsearchesController < ApplicationController

  def search
    @model = Book
    @word = params[:content]
    @books = Book.where("category LIKE ?", "%#{@word}%")
    render "tagsearches/tagsearch"
  end

#モデルクラス.where("列名 LIKE ?", "%値%")  # 値(文字列)を含む
#モデルクラス.where("列名 LIKE ?", "値_")   # 値(文字列)と末尾の1文字

end

