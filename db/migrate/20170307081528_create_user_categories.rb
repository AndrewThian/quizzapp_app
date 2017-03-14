class CreateUserCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :user_categories do |t|
      t.integer :category_level
      t.integer :category_exp
      t.references :user, foreign_key: true
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
