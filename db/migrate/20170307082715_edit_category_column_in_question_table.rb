class EditCategoryColumnInQuestionTable < ActiveRecord::Migration[5.0]
  def change
    rename_column :questions, :category, :category_name
  end
end
