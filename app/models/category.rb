class Category < ApplicationRecord

  validates :category, presence:true

  has_many :books, dependent: :destroy
end
