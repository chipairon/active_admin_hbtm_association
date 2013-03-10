class Post < ActiveRecord::Base
  attr_accessible :body, :title, :categories
  has_and_belongs_to_many :categories

  search_methods :category_ids_eq

  scope :category_ids_eq, lambda { |category_id|
    Post.joins(:categories).where("category_id = ?", category_id)
  }
end
