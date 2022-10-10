# frozen_string_literal: true

FactoryBot.define do
  # TailwindDsl::Transformers::RawComponents::Root
  factory :raw_components_root_hash, class: Hash do
    design_systems { [build(:raw_components_design_system_hash)] }

    initialize_with { attributes }
  end
end
