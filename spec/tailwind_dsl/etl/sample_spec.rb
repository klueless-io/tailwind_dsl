# frozen_string_literal: true

require 'spec_helper'

return if ENV.fetch('GITHUB_ACTIONS', nil)

# 00-raw_components
#   This is a custom folder with HTML structures that are used to generate the constituent components
# 01-data
#   This contains generated uikit JSON data
RSpec.describe TailwindDsl::Etl::RawComponents::Load do
  let(:instance) { described_class.new }
  let(:target_root_path) { File.join(SPEC_FOLDER, 'samples/01-data') }

  context 'sample' do
    let(:source_root_path) { 'spec/samples/00-raw_components' }

    before do
      instance.add_design_system(File.join(source_root_path, 'tui'))
      instance.add_design_system(File.join(source_root_path, 'noq'))
    end

    it { instance.write(File.join(target_root_path, 'uikit.test.json')) }
  end

  context 'live' do
    let(:source_root_path) { File.expand_path('~/dev/kgems/k_templates/templates/tailwind') }

    before do
      instance.add_design_system(File.join(source_root_path, 'tui'))
      instance.add_design_system(File.join(source_root_path, 'noq'))
    end

    it { instance.write(File.join(target_root_path, 'uikit.live.json')) }
  end
end

# This will generate 02-components by reading data from 00-raw_components and 01-data/uikit.test.json
RSpec.describe TailwindDsl::Etl::ComponentStructures::Generator do
  include_context :get_uikit

  subject { instance }

  let(:instance) { described_class.new(uikit, source_root_path, target_root_path) }

  let(:source_root_path) { File.join(SPEC_FOLDER, 'samples/00-raw_components') }
  let(:target_root_path) { File.join(SPEC_FOLDER, 'samples/02-components') }

  context 'sample' do
    before { FileUtils.mkdir_p(target_root_path) }

    it { instance.generate }
  end
end

# This will extract additional data using GPT3 from 02-components folder
# and placing side by side with existing files
RSpec.describe TailwindDsl::Etl::Extractors::BatchExtraction do
  include_context :get_uikit

  let(:source_root_path) { File.join(SPEC_FOLDER, 'samples/00-raw_components') }
  let(:target_root_path) { File.join(SPEC_FOLDER, 'samples/02-components') }

  let(:components) do
    TailwindDsl::Etl::ComponentStructures::RawComponentQuery.query(uikit,
                                                                   source_root_path: source_root_path,
                                                                   target_root_path: target_root_path)
                                                            .components
  end

  let(:instance) do
    described_class.new(
      components,
      target_root_path,
      batch_size: 1,
      use_prompt: false,
      filter_design_system: 'tui',
      extract_handler: extract_handler
    )
  end

  let(:extract_handler) { TailwindDsl::Etl::Extractors::DataExtractor }

  # context 'sample' do
  #   before { FileUtils.mkdir_p(target_root_path) }

  #   it { instance.extract }
  # end
end
