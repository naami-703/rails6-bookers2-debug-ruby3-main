class Entry < ApplicationRecord
  # ユーザーとチャットルームの中間テーブル(room管理）

  belongs_to :user
  belongs_to :room
end
