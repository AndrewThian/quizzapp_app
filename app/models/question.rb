class Question < ApplicationRecord
  belongs_to :category

  has_many :completed_questions
  has_many :user_categories, through: :completed_questions
end
