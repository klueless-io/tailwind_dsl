# frozen_string_literal: true

RSpec.shared_context :get_uikit do
  let(:design_systems_file) { File.join(SPEC_FOLDER, 'samples/01-data/uikit.test.json') }
  let(:design_systems_data) { JSON.parse(File.read(design_systems_file), symbolize_names: true) }
  let(:uikit) { ::TailwindDsl::Etl::RawComponents::UiKit.new(design_systems_data) }
end
