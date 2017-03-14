class AddColumnToQuestion < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :incorrect_answers, :string, array: true, default: []
    add_column :questions, :exp, :integer
    add_reference :questions, :category, foreign_key: true
  end
end
