# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TailwindDsl::Etl::RawComponents::Load do
  let(:instance) { described_class.new }
  let(:target_root_path) { File.join(SPEC_FOLDER, 'samples/00-data') }

  context 'sample' do
    let(:source_root_path) { 'spec/samples/01-raw_components' }

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

RSpec.describe TailwindDsl::Etl::ComponentStructures::Generator do
  include_context :get_uikit

  subject { instance }

  let(:instance) { described_class.new(uikit, source_root_path, target_root_path) }

  let(:source_root_path) { File.join(SPEC_FOLDER, 'samples/01-raw_components') }
  let(:target_root_path) { File.join(SPEC_FOLDER, 'samples/02-components') }

  context 'sample' do
    before { FileUtils.mkdir_p(target_root_path) }

    it { instance.generate }

    it { puts ENV['GITHUB_ACTIONS'] }
  end
end

# describe 'sample - gpt3 data extractor' do
#   let(:extract_handler) { TailwindDsl::Etl::Extractors::DataExtractor }

#   fit do
#     instance.extract
#   end
# end
