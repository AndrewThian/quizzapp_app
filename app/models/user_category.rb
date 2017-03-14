class UserCategory < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :completed_questions
  has_many :questions, through: :completed_questions
end
