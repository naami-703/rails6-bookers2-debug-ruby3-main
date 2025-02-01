class Relationship < ApplicationRecord

  # フォローするユーザーのidとの関連付け
   belongs_to :follower, class_name: "User"
  # フォローされるユーザーのidとの関連付け
   belongs_to :followed, class_name: "User"

end
