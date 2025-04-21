class Book < ApplicationRecord
  belongs_to :user
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  validates :category,presence:true

  has_one_attached :profile_image
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :read_counts, dependent: :destroy

  
  # いいねが多い順並び変え用
  # -> { ... }  関連付けに特定の条件を指定
  has_many :week_favorites, -> { where(created_at: ((Time.current.at_end_of_day - 6.day).at_beginning_of_day)..(Time.current.at_end_of_day)) }, class_name: 'Favorite'

  # 投稿を新着順・いいねの多い順に並び替え機能
  scope :latest, -> { order(created_at: :desc)}
  scope :favorites, -> { order(favorites: :desc)}

  scope :create_today, -> {where(create_at: Time.zone.now.all_day)}
  scope :create_yesterday, -> {where(create_at: 1.day.ago.all_day)}
  scope :create_this_week, -> {where(create_at: 6.day.ago.at_beginning_of_day..Time.zone.now.end_of_day)}
  scope :create_last_week, -> {where(create_at: 2.week.ago.at_beginning_of_day..1.week.ago.end_of_day)}
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
  # 検索方法分岐
  # titleは検索対象であるbooksテーブル内のカラム名
  # % → 0文字以上の任意の文字列 （例）#{word}% → 前方一致
  # whereメソッドを使いデータベースから該当データを取得
  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end

end
