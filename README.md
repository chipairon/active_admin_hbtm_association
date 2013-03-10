active_admin_hbtm_association
=============================

How to have active_admin filters working with a has_and_belongs_to_many association.

The issue:
Let's have two models: Post and Category related via a has_and_belongs_to_many association.
Let's try to make a filter for the Post index admin page:

```ruby
ActiveAdmin.register Post do
  # just putting "filter :categories" does not show up any filters in the view.
  filter :category_ids,
    label: 'categories',
    as: :select,
    collection: Category.all.collect { |category| [category.name, category.id] }
end
```

The following exception is thrown:

```ruby
undefined method `category_ids_eq' for #<MetaSearch::Searches::Post:0x007fcc483bf918>
```

The solution:
Create the method MetaSearch is looking for as a scope and make it 'findable' to MetaSearch declaring it as a 'search method':

```ruby
class Post < ActiveRecord::Base
  attr_accessible :body, :title, :categories
  has_and_belongs_to_many :categories

  search_methods :category_ids_eq

  scope :category_ids_eq, lambda { |category_id|
    Post.joins(:categories).where("category_id = ?", category_id)
  }
end
```


The set up:
```bash
rails new active_admin_hbtm_association -T
```
- Add gem active_admin to gem file

```bash
bundle
rails g active_admin:install
rake db:migrate
```

- Generate the models:

```bash
rails g model post title:string body:text -T
rails g model category name:string -T
``` 

- Create the association table:

```bash
rails g migration CreateTableCategoriesPosts
```
- Add associations to models:

```bash
rake db:migrate
rails g active_admin:resource post
rails g active_admin:resource category
```

- Active admin does not have (afaik) direct support to HABTM associations so at this point we three options:
  - A) customize the active admin forms to be able to manage the association throw the admin views.
  - B) use the console to create some associations.
  - C) go to the database itself and create some associations in SQL.

I am going to use B for clarity and simplicity:

```ruby
rails c
sports_category = Category.create(name: "sports")
news_category = Category.create(name: "news")
cooking_category = Category.create(name: "cooking")
post_about_cooking = Post.create(title: "about cooking 1", body: "about cooking 1 body")
post_about_news = Post.create(title: "about news 1", body: "about news 1 body")
news_category.posts << post_about_news
cooking_category.posts << post_about_cooking
```
