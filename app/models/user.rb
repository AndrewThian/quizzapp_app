class User < ApplicationRecord
  has_many :user_categories
  has_many :categories, through: :user_categories

  # validate new user
  validates :name, presence: true, length: {in: 1..72}
  validates :email, presence: true, uniqueness: {case_sensitive: false}
  validates :password, length: {in: 1..72}, on: :create

  has_secure_password

  def self.authenticate(params)
    User.find_by_email(params[:email]).try(:authenticate, params[:password])
  end
end
