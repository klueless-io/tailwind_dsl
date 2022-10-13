# frozen_string_literal: true

FactoryBot.define do
  factory :raw_components_source_file, class: TailwindDsl::Etl::RawComponents::SourceFile do
    skip_create
    initialize_with { new(attributes) }

    name                  { '03.html' }
    file_name             { '03.html' }
    file_name_only        { '03' }
    # absolute_file         { '/Users/davidcruwys/dev/kgems/k_templates/templates/tailwind/tui/ecommerce/page/product-pages/03.html' }
    file                  { 'ecommerce/page/product-pages/03.html' }

    # target - handle outside of the factory
  end
end
