class EditUserCategory < ActiveRecord::Migration[5.0]
  def change
    change_column :user_categories, :highscore, :integer, :default => 0
  end
end
