# frozen_string_literal: true

FactoryBot.define do
  factory :raw_components_design_systems, class: TailwindDsl::Etl::RawComponents::UiKit do
    initialize_with { attributes }
    skip_create

    # design_systems { [build(:raw_components_design_system)] }
  end
end
