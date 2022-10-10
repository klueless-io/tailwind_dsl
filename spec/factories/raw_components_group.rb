# frozen_string_literal: true

FactoryBot.define do
  # TailwindDsl::Transformers::RawComponents::Group
  factory :raw_components_group_hash, class: Hash do
    key                   { 'ecommerce.page.category_pages' }
    type                  { 'category-pages' }
    folder                { 'ecommerce/page/category-pages' }
    sub_keys              { %w[ecommerce page category-pages] }
    files                 { [build(:raw_components_source_file_hash)] }

    initialize_with { attributes }
  end
end
