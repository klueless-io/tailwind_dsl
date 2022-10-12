# frozen_string_literal: true

FactoryBot.define do
  factory :raw_components_target_file, class: TailwindDsl::Etl::RawComponents::TargetFile do
    skip_create
    initialize_with { new(attributes) }

    html_file             { 'ecommerce/page/product-pages/03.html' }
    clean_html_file       { 'ecommerce/page/product-pages/03.clean.html' }
    tailwind_config_file  { 'ecommerce/page/product-pages/03.tailwind.config.js' }
    settings_file         { 'ecommerce/page/product-pages/03.settings.json' }
    data_file             { 'ecommerce/page/product-pages/03.data.json' }
    astro_file            { 'ecommerce/page/product-pages/03.astro' }
  end
end
