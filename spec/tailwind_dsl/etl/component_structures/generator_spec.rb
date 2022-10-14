# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TailwindDsl::Etl::ComponentStructures::Generator do
  include_context :use_temp_folder

  subject { instance }

  let(:instance) { described_class.new(uikit, source_root_path, target_root_path) }

  let(:design_systems_file) { File.join(SPEC_FOLDER, 'samples/input/uikit.json') }
  let(:design_systems_data) { JSON.parse(File.read(design_systems_file), symbolize_names: true) }
  let(:uikit) { ::TailwindDsl::Etl::RawComponents::UiKit.new(design_systems_data) }

  let(:source_root_path) { File.join(SPEC_FOLDER, 'samples/components') }
  let(:target_root_path) { File.join(temp_folder, 'components') }

  describe '.components' do
    subject { instance.components }

    before { instance.generate }

    it { is_expected.to be_a(Array) }
    it 'has a records with expected data' do
      expect(subject).to be_a(Array)
      expect(subject.first)
        .to have_attributes(design_system: have_attributes(name: 'tui'))
        .and have_attributes(component_group: have_attributes(key: 'marketing.section.cta'))
        .and have_attributes(absolute_component: have_attributes(source_file: end_with('marketing/section/cta/03.html')))
        .and have_attributes(relative_component: have_attributes(source_file: end_with('marketing/section/cta/03.html')))
    end
  end

  context 'check mock data' do
    it { expect(uikit.design_systems.length).to be > 0 }
  end

  describe 'initialize' do
    it { is_expected.to be_a described_class }

    describe '.uikit' do
      subject { instance.uikit }

      it { is_expected.to be_a(uikit.class) }
    end

    describe '.source_root_path' do
      subject { instance.source_root_path }

      it { is_expected.to eq source_root_path }
    end

    describe '.target_root_path' do
      subject { instance.target_root_path }

      it { is_expected.to eq target_root_path }
    end
  end

  describe '#generate' do
    context 'when target path does not exist' do
      let(:target_root_path) { File.join(temp_folder, 'bad') }

      it 'raises an error' do
        expect { instance.generate }.to raise_error('Target path does not exist')
      end
    end

    context 'when resetting root path' do
      let(:instance) { described_class.new(uikit, source_root_path, target_root_path, reset_root_path: reset_root_path) }

      before do
        FileUtils.mkdir_p(File.join(target_root_path, 'a', 'b', 'c'))

        instance.generate
      end

      context 'when reset_root_path is false' do
        let(:reset_root_path) { false }

        it 'does not delete the content under root path' do
          expect(File.exist?(File.join(target_root_path, 'a', 'b', 'c'))).to be true
        end
      end

      context 'when reset_root_path is true' do
        let(:reset_root_path) { true }

        it 'deletes the content under root path' do
          expect(File.exist?(File.join(target_root_path, 'a', 'b', 'c'))).to be false
        end
      end
    end

    context 'when target path exists and #generate' do
      before do
        FileUtils.mkdir_p(target_root_path)

        # uikit.add_design_system(File.join(component_path, 'tui'))

        instance.generate
      end

      let(:cta_folder) { 'tui/marketing/section/cta' }
      let(:cta_component) { "#{cta_folder}/01" }
      let(:cta_html) { "#{cta_component}.html" }
      let(:cta_clean_html) { "#{cta_component}.clean.html" }
      let(:cta_tailwind_config) { "#{cta_component}.tailwind.config.js" }
      let(:cta_settings) { "#{cta_component}.settings.json" }
      let(:cta_data) { "#{cta_component}.data.json" }
      let(:cta_astro) { "#{cta_component}.astro" }

      context 'design system folder is created' do
        it { expect(File.exist?(File.join(target_root_path, 'tui'))).to be_truthy }
      end

      context 'component sub folder is created' do
        it { expect(File.exist?(File.join(target_root_path, cta_folder))).to be true }
      end

      context 'component html' do
        let(:file) { File.join(target_root_path, cta_html) }
        let(:content) { File.read(file) }

        it 'creates a file' do
          expect(File.exist?(file)).to be_truthy
        end

        it 'has the original content comments' do
          expect(content).to include('<!--').and include('This example requires some changes to your config:')
        end

        it 'has the original blank lines' do
          expect(content).to include("<h1>\n  \n</h1>")
        end
      end

      context 'component html (cleaned)' do
        let(:file) { File.join(target_root_path, cta_clean_html) }
        let(:content) { File.read(file) }

        it 'creates a file' do
          expect(File.exist?(file)).to be_truthy
        end

        it 'comments are left unaltered' do
          expect(content).not_to include('<!--')
          expect(content).not_to include('This example requires some changes to your config:')
        end

        it 'blank lines are kept' do
          expect(content).not_to include("<h1>\n  \n</h1>")
        end
      end

      context 'component tailwind config' do
        let(:file) { File.join(target_root_path, cta_tailwind_config) }
        let(:content) { File.read(file) }

        context 'when the component has a tailwind config' do
          it 'creates a file' do
            expect(File.exist?(file)).to be_truthy
          end

          it 'has content' do
            expect(content).to include("require('@tailwindcss/aspect-ratio')")
          end
        end

        context 'when the component does not have a tailwind config' do
          let(:cta_component) { "#{cta_folder}/03" }

          it 'creates a file' do
            expect(File.exist?(file)).to be_falsey
          end
        end
      end

      fcontext 'component settings' do
        let(:file) { File.join(target_root_path, cta_settings) }
        let(:settings) { JSON.parse(File.read(file)) }

        it 'creates a file' do
          expect(File.exist?(file)).to be_truthy
        end

        it 'has the expected content' do
          expect(settings.dig('tailwind_config', 'plugins', 'forms')).to be_falsey
          expect(settings.dig('tailwind_config', 'plugins', 'aspect_ratio')).to be_truthy
          expect(settings.dig('tailwind_config', 'plugins', 'line_clamp')).to be_falsey
          expect(settings.dig('tailwind_config', 'plugins', 'typography')).to be_falsey
        end

        context 'when the component has all settings' do
          let(:cta_component) { "#{cta_folder}/02" }
          it 'has the expected content' do
            expect(settings.dig('tailwind_config', 'plugins', 'forms')).to be_truthy
            expect(settings.dig('tailwind_config', 'plugins', 'aspect_ratio')).to be_truthy
            expect(settings.dig('tailwind_config', 'plugins', 'line_clamp')).to be_truthy
            expect(settings.dig('tailwind_config', 'plugins', 'typography')).to be_truthy
          end
        end

        context 'when the component has no settings' do
          let(:cta_component) { "#{cta_folder}/03" }
          it 'has the expected content' do
            expect(settings.dig('tailwind_config', 'plugins', 'forms')).to be_falsey
            expect(settings.dig('tailwind_config', 'plugins', 'aspect_ratio')).to be_falsey
            expect(settings.dig('tailwind_config', 'plugins', 'line_clamp')).to be_falsey
            expect(settings.dig('tailwind_config', 'plugins', 'typography')).to be_falsey
          end
        end
      end
    end
  end
end
