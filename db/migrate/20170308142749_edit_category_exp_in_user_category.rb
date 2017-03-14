class EditCategoryExpInUserCategory < ActiveRecord::Migration[5.0]
  def change
    add_column :user_categories, :highscore, :integer
    remove_column :user_categories, :category_level
  end
end
