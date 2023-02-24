class AddColumnToPost < ActiveRecord::Migration[7.0]
  def change
    remove_column :posts, :title, :string
    add_column :posts, :name, :string
    add_column :posts, :classname, :string
    add_column :posts, :strength, :string
    add_column :posts, :skill, :string
    add_column :posts, :dexterity, :string
  end
end
