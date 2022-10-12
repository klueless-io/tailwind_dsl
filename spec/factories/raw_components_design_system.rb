# frozen_string_literal: true

FactoryBot.define do
  factory :raw_components_design_system, class: TailwindDsl::Etl::RawComponents::DesignSystem do
    skip_create
    initialize_with { new(attributes) }

    name  { 'tui' }
    path  { '/Users/davidcruwys/dev/kgems/k_templates/templates/tailwind/tui' }
    stats do
      {
        'ecommerce.page.category_pages': 5,
        'ecommerce.page.product_pages': 5
      }
    end

    # groups - handle outside of the factory
  end
end
