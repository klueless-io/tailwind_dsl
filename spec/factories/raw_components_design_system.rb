# frozen_string_literal: true

FactoryBot.define do
  # TailwindDsl::Transformers::RawComponents::DesignSystem
  factory :raw_components_design_system_hash, class: Hash do
    name  { 'tui' }
    path  { '/Users/davidcruwys/dev/kgems/k_templates/templates/tailwind/tui' }
    stats do
      {
        'ecommerce.page.category_pages': 5,
        'ecommerce.page.product_pages': 5
      }
    end
    groups { [build(:raw_components_group_hash)] }

    initialize_with { attributes }
  end
end
