class AddImageToArticles < ActiveRecord::Migration[8.0]
  def change
    add_column :articles, :image, :string
  end
end
