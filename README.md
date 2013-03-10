active_admin_hbtm_association
=============================

How to have active_admin filters working with a has_and_belongs_to_many association.

The issue:


The solution:


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
