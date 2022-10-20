# frozen_string_literal: true

require 'spec_helper'

class FakeExtractor
  def extract_data(component)
    puts "extract data for #{component}"
  end

  def extract_model(component)
    puts "extract model for #{component}"
  end
end

RSpec.describe TailwindDsl::Etl::ComponentModels::Extractor do
  include_context :use_temp_folder
  include_context :get_uikit

  subject { instance }

  let(:raw_component_root_path) { File.join(SPEC_FOLDER, 'samples/components') }
  let(:component_structure_root_path) { File.join(temp_folder, 'components') }
  let(:component_model_root_path) { File.join(temp_folder, 'components') }
  let(:extract_handler) { FakeExtractor }

  let(:components) do
    TailwindDsl::Etl::ComponentStructures::RawComponentQuery.query(uikit,
                                                                   source_root_path: raw_component_root_path,
                                                                   target_root_path: component_structure_root_path)
                                                            .components
  end

  let(:instance) do
    TailwindDsl::Etl::ComponentModels::Extractor.new(
      components,
      component_model_root_path,
      batch_size: 1,
      use_prompt: false,
      filter_design_system: 'tui',
      extract_handler: extract_handler
    )
  end

  context 'initialize' do
    it { is_expected.to be_a described_class }

    context '.components' do
      subject { instance.components.first }

      it { is_expected.to be_a(::TailwindDsl::Etl::ComponentStructures::RawComponentQuery::Component) }
    end

    context '.target_root_path' do
      subject { instance.target_root_path }

      it { is_expected.to eq(component_model_root_path) }
    end

    context '.batch_size' do
      subject { instance.batch_size }

      it { is_expected.to eq(1) }
    end

    context '.use_prompt' do
      subject { instance.use_prompt }

      it { is_expected.to eq(false) }
    end

    context '.filter_design_system' do
      subject { instance.filter_design_system }

      it { is_expected.to eq('tui') }
    end

    context '.extract_handler' do
      subject { instance.extract_handler }

      it { is_expected.to be_a(FakeExtractor) }
    end
  end

  describe '#extract' do
    let(:extract_handler) { FakeExtractor }

    before { instance.extract }

    it { subject }
  end

  # context 'examples' do
  #   let(:output_path) { File.join(SPEC_FOLDER, 'samples/output') }

  #   context 'sample' do
  #     before do
  #       instance.add_design_system(File.join(component_path, 'tui'))
  #       instance.add_design_system(File.join(component_path, 'noq'))
  #     end

  #     it { instance.write(File.join(output_path, 'uikit.sample.json')) }
  #   end

  #   context 'live' do
  #     let(:component_path) { File.expand_path('~/dev/kgems/k_templates/templates/tailwind') }

  #     before do
  #       instance.add_design_system(File.join(component_path, 'tui'))
  #       instance.add_design_system(File.join(component_path, 'noq'))
  #     end

  #     it { instance.write(File.join(output_path, 'uikit.live.json')) }
  #   end
  # end
end
