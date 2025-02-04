class Message < ApplicationRecord
  # ユーザーとチャットルームの中間テーブル(message管理）

  #メッセージが空白の場合、保存されない
  validates :message, presence: true
  
  belongs_to :user
  belongs_to :room

end
