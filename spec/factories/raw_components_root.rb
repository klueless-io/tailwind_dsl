# frozen_string_literal: true

FactoryBot.define do
  factory :raw_components_root, class: TailwindDsl::Transformers::RawComponents::Root do
    skip_create

    # design_systems { [build(:raw_components_design_system_hash)] }

    initialize_with { attributes }
  end
end
