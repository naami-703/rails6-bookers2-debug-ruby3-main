class Favorite < ApplicationRecord

  belongs_to :user
  belongs_to :book


  # １つのコメントに対しいいねを重複できない状態に制限
  validates :user_id, uniqueness: {scope: :book_id}

end
