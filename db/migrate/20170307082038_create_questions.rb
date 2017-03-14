class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.string :category
      t.string :type
      t.string :difficulty
      t.text :question
      t.string :correct_answer

      t.timestamps
    end
  end
end
