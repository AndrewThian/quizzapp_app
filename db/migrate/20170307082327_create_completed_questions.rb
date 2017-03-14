class CreateCompletedQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :completed_questions do |t|
      t.references :user_category, foreign_key: true
      t.references :question, foreign_key: true

      t.timestamps
    end
  end
end
