class CompletedQuestion < ApplicationRecord
  belongs_to :user_category
  belongs_to :question
end
