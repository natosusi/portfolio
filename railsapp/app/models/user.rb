class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :lendings
  has_many :reviews
  has_many :likes, dependent: :destroy
  has_many :like_books, through: :likes, source: :book
  validates :name,{presence: true}
end
