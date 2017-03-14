class EditUserCategoryExp < ActiveRecord::Migration[5.0]
  def change
    change_column :user_categories, :category_exp, :integer, :default => 0
  end
end
