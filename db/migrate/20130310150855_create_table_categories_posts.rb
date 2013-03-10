class CreateTableCategoriesPosts < ActiveRecord::Migration
  def change
    create_table :categories_posts do |t|
      t.references :post
      t.references :category
    end
  end
end
