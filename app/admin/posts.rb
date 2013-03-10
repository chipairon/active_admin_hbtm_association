ActiveAdmin.register Post do
  filter :category_ids,
    label: 'categories',
    as: :select,
    collection: Category.all.collect { |category| [category.name, category.id] }
end
