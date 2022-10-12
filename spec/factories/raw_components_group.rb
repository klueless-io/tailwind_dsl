# frozen_string_literal: true

FactoryBot.define do
  factory :raw_components_group, class: TailwindDsl::Etl::RawComponents::Group do
    skip_create
    initialize_with { new(attributes) }

    key                   { 'ecommerce.page.category_pages' }
    type                  { 'category-pages' }
    folder                { 'ecommerce/page/category-pages' }
    sub_keys              { %w[ecommerce page category-pages] }

    # files - handle outside of the factory
  end
end
