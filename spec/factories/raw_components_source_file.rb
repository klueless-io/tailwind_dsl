# frozen_string_literal: true

FactoryBot.define do
  # TailwindDsl::Transformers::RawComponents::SourceFile
  factory :raw_components_source_file_hash, class: Hash do
    name                  { '03.html' }
    file_name             { '03.html' }
    file_name_only        { '03' }
    absolute_file         { '/Users/davidcruwys/dev/kgems/k_templates/templates/tailwind/tui/ecommerce/page/product-pages/03.html' }
    file                  { 'ecommerce/page/product-pages/03.html' }
    target                { build(:raw_components_target_file_hash) }

    initialize_with { attributes }
  end
end
