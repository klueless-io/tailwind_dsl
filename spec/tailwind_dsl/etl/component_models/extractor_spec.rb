# frozen_string_literal: true

require 'spec_helper'

class FakeExtractor
  def extract_data(component)
    # puts "extract #{component.relative.source_file} to #{component.relative.target_data_file}"
    File.write(component.absolute.target_data_file, 'fake data')
  end

  def extract_model(component)
    # puts "extract #{component.relative.source_file} to #{component.relative.target_model_file}"
    File.write(component.absolute.target_model_file, 'fake model')
  end
end

RSpec.describe TailwindDsl::Etl::ComponentModels::Extractor do
  include_context :use_temp_folder
  include_context :get_uikit

  subject { instance }

  let(:source_root_path) { File.join(SPEC_FOLDER, 'samples/01-raw_components') }
  let(:target_root_path) { File.join(temp_folder, 'components') }

  # let(:raw_component_root_path) { File.join(SPEC_FOLDER, 'samples/02-components') }
  # let(:component_root_path) { File.join(temp_folder, 'components') }
  let(:batch_size) { 1 }
  let(:extract_handler) { FakeExtractor }

  let(:components) do
    TailwindDsl::Etl::ComponentStructures::RawComponentQuery.query(uikit,
                                                                   source_root_path: source_root_path,
                                                                   target_root_path: target_root_path)
                                                            .components
  end

  let(:instance) do
    TailwindDsl::Etl::ComponentModels::Extractor.new(
      components,
      target_root_path,
      batch_size: batch_size,
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

      it { is_expected.to eq(target_root_path) }
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

    # fit { subject }
    context 'target folder does not exist' do
      it { expect { instance.extract }.to raise_error(/Folder does not exist/) }
    end

    context 'target folder exists' do
      before { FileUtils.mkdir_p(component_folder) }

      let(:component_folder) { File.join(target_root_path, 'tui', 'marketing', 'section', 'cta') }

      context 'batch_size = 1, call once' do
        let(:batch_size) { 1 }

        it do
          instance.extract
          expect(File.exist?(File.join(component_folder, '01.data.json'))).to be_truthy
          expect(File.exist?(File.join(component_folder, '02.data.json'))).to be_falsey
          expect(File.exist?(File.join(component_folder, '03.data.json'))).to be_falsey
        end
      end

      context 'batch_size = 2, call once' do
        let(:batch_size) { 2 }

        it do
          instance.extract

          expect(File.exist?(File.join(component_folder, '01.data.json'))).to be_truthy
          expect(File.exist?(File.join(component_folder, '02.data.json'))).to be_truthy
          expect(File.exist?(File.join(component_folder, '03.data.json'))).to be_falsey
        end
      end

      context 'batch_size = 1, call twice' do
        let(:batch_size) { 1 }

        it do
          instance.extract
          instance.extract

          expect(File.exist?(File.join(component_folder, '01.data.json'))).to be_truthy
          expect(File.exist?(File.join(component_folder, '02.data.json'))).to be_truthy
          expect(File.exist?(File.join(component_folder, '03.data.json'))).to be_falsey
        end
      end
    end
  end
end
