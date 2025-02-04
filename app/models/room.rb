class Room < ApplicationRecord
  # 相互フォロー同士のチャットルーム
  
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy

end
