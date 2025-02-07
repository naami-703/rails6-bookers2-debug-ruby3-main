class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, length: { minimum: 2, maximum: 20 }
  validates :introduction, length: { maximum: 50 }

  has_many :books, dependent: :destroy
  has_one_attached :profile_image
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :read_counts, dependent: :destroy

  # 相互フォローチャットルームの中間テーブル
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy

  # フォローした関係
  # アソシエーションが繋がっているテーブル名、class_nameは実際のモデルの名前、foreign_keyは外部キー
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # フォローされた関係
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # フォロー一覧
  # has_many :テーブル名, through: :中間テーブル名, source: :参照するカラム
  has_many :followings, through: :relationships, source: :followed
  # フォロワー一覧
  has_many :followers, through: :reverse_of_relationships, source: :follower

  # フォローしたときの処理
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end
  # フォローを外すときの処理
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  # フォローしているか判定
  def following?(user)
    followings.include?(user)
  end

  # 検索方法分岐
  # nameは検索対象であるusersテーブル内のカラム名
  # % → 0文字以上の任意の文字列 （例）#{word}% → 前方一致
  # whereメソッドを使いデータベースから該当データを取得
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end

  def favotited_by?(book_id)
    favorites.where(book_id: book_id).exists?
  end

  def get_user_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
      profile_image.variant(resize_to_limit: [width,height]).processed
  end

  # ゲストユーザー設定
  # find_or_create_by：データの検索と作成を自動的に判断して処理を行う、Railsのメソッド
  # find_or_create_by!の「!」を付与することで、処理がうまくいかなかった場合にエラーが発生
  # SecureRandom.urlsafe_base64：ランダムな文字列を生成するRubyのメソッド
  GUEST_USER_EMAIL = "guest@example.com"
  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end

  # ゲストユーザー判定
  def guest_user?
    email == GUEST_USER_EMAIL
  end

end

