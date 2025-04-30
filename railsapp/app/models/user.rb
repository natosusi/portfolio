class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :lendings
  has_many :reviews
  validates :name,{presence: true}
  #validates :address,{presence: true, uniqueness: true}
end
