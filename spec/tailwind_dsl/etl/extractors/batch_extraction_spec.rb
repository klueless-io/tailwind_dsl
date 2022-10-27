# frozen_string_literal: true

require 'spec_helper'

class FakeExtractor < TailwindDsl::Etl::Extractors::BaseExtractor
  def target_file
    component.absolute.target_data_file
  end

  def extract
    # puts "extract #{component.relative.source_file} to #{component.relative.target_data_file}"
    File.write(target_file, 'fake data')
  end
end

RSpec.describe TailwindDsl::Etl::Extractors::BatchExtraction do
  include_context :use_temp_folder
  include_context :get_uikit

  subject { instance }

  let(:source_root_path) { File.join(SPEC_FOLDER, 'samples/00-raw_components') }
  let(:target_root_path) { File.join(temp_folder, 'components') }

  # let(:raw_component_root_path) { File.join(SPEC_FOLDER, 'samples/02-components') }
  # let(:component_root_path) { File.join(temp_folder, 'components') }
  let(:batch_size) { 1 }
  let(:filter) { { design_system: 'tui' } }
  let(:extract_handler) { FakeExtractor }

  let(:components) do
    TailwindDsl::Etl::ComponentQuery.query(uikit,
                                           source_root_path: source_root_path,
                                           target_root_path: target_root_path)
                                    .components
  end

  let(:instance) do
    described_class.new(
      components,
      target_root_path,
      batch_size: batch_size,
      filter: filter, # ADD SUPPORT FOR application-ui/application-shells/multi-column
      extract_handler: extract_handler
    )
  end

  context 'initialize' do
    it { is_expected.to be_a described_class }

    context '.components' do
      subject { instance.components.first }

      it { is_expected.to be_a(::TailwindDsl::Etl::ComponentQuery::Component) }
    end

    context '.target_root_path' do
      subject { instance.target_root_path }

      it { is_expected.to eq(target_root_path) }
    end

    context '.batch_size' do
      subject { instance.batch_size }

      it { is_expected.to eq(1) }
    end

    context '.filter' do
      subject { instance.filter }

      it { is_expected.to include(design_system: 'tui') }
    end

    context '.extractor' do
      subject { instance.extractor }

      it { is_expected.to be_a(FakeExtractor) }

      context 'when extract_handler is not set' do
        let(:extract_handler) { nil }

        it { expect { subject }.to raise_error(RuntimeError, 'Extract handler is required') }
      end

      context 'when extract_handler does not implement :extract method' do
        let(:extract_handler) { Class.new }

        it { expect { subject }.to raise_error(RuntimeError, 'Extract handler must implement extract method') }
      end

      context 'when extract_handler does not implement :target_file method' do
        let(:extract_handler) do
          Class.new do
            def extract; end
          end
        end

        it { expect { subject }.to raise_error(RuntimeError, 'Extract handler must implement target_file method') }
      end
    end
  end

  describe '#extract' do
    let(:extract_handler) { FakeExtractor }
    let(:batch_size) { 1 }

    context 'when batch_size is 0' do
      let(:batch_size) { 0 }

      it { expect { instance.extract }.to raise_error(/Batch size must be greater than 0/) }
    end

    context 'target folder does not exist' do
      it { expect { instance.extract }.to raise_error(/Folder does not exist/) }
    end

    context 'target folder exists' do
      before { FileUtils.mkdir_p(component_folder) }

      let(:component_folder) { File.join(target_root_path, 'tui', 'marketing', 'section', 'cta') }

      context 'batch_size = 1, call once' do
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
        it do
          instance.extract
          instance.extract

          expect(File.exist?(File.join(component_folder, '01.data.json'))).to be_truthy
          expect(File.exist?(File.join(component_folder, '02.data.json'))).to be_truthy
          expect(File.exist?(File.join(component_folder, '03.data.json'))).to be_falsey
        end
      end

      context 'when filtering for design_system' do
        let(:filter) { { design_system: 'noq' } }
        let(:component_folder) { File.join(target_root_path, 'noq', 'card') }

        it do
          instance.extract

          expect(File.exist?(File.join(component_folder, 'style1.data.json'))).to be_truthy
          expect(File.exist?(File.join(component_folder, 'style2.data.json'))).to be_falsey
        end
      end

      context 'when filtering for group key' do
        let(:filter) { { design_system: 'tui', group_key: 'marketing.section.stats' } }
        let(:component_folder) { File.join(target_root_path, 'tui', 'marketing', 'section', 'stats') }

        it do
          instance.extract

          expect(File.exist?(File.join(component_folder, '01.data.json'))).to be_truthy
          expect(File.exist?(File.join(component_folder, '02.data.json'))).to be_falsey
        end
      end

      # Add include and exclude FILTERS
      # folder: application-ui/application-shells/multi-column
      # group_keys: marketing.section.stats, marketing.section.cta
      # folders: application-ui/application-shells/multi-column, application-ui/application-shells/sidebars

      context 'when filtering group key exclusion' do
        # when you exclude stats, means we are including cta
        let(:filter) { { design_system: 'tui', exclude_group_key: 'marketing.section.cta' } }
        let(:component_folder) { File.join(target_root_path, 'tui', 'marketing', 'section', 'stats') }

        it do
          instance.extract

          expect(File.exist?(File.join(component_folder, '01.data.json'))).to be_truthy
          expect(File.exist?(File.join(component_folder, '02.data.json'))).to be_falsey
        end
      end
    end
  end
end
