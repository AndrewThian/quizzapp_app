class AddColumToCategory < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :icon_source, :string
  end
end
