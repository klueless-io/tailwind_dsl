# frozen_string_literal: true

require 'spec_helper'

# Generated files are transient, because they can be regenerated at any time
GEN_CLEAN_HTML  = '01.clean.html'
GEN_HTML        = '01.html'
GEN_SETTINGS    = '01.settings.json'
GEN_TAILWIND    = '01.tailwind.config.js'

# Extracted files are not transient, because they use AI and sometimes manual editing.
# Once these files are created, they should not be automatically removed.
EXT_DATA        = '01.data.json'
EXT_MODEL       = '01.model.rb'

RSpec.describe TailwindDsl::Etl::ComponentStructures::Generator do
  include_context :use_temp_folder
  include_context :get_uikit

  subject { instance }

  let(:instance) { described_class.new(uikit, source_root_path, target_root_path) }

  let(:source_root_path) { File.join(SPEC_FOLDER, 'samples/01-raw_components') }
  let(:target_root_path) { File.join(temp_folder, 'components') }
  # let(:target_root_path) { File.join(SPEC_FOLDER, 'samples/02-components') } # If you need to refresh 02-component_structures

  describe '.components' do
    subject { instance.components }

    before do
      FileUtils.mkdir_p(target_root_path)

      instance.generate
    end

    it { is_expected.to be_a(Array) }
    it 'has a records with expected data' do
      expect(subject).to be_a(Array)
      expect(subject.first)
        .to include(name: 'style1')
        .and have_attributes(design_system: have_attributes(name: 'noq'))
        .and include(group: include(key: 'card'))
        .and include(absolute: include(source_file: end_with('card/style1.html')))
        .and include(relative: include(source_file: end_with('card/style1.html')))
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
        FileUtils.mkdir_p(File.join(target_root_path, 'b', 'generated_only', 'b'))
        FileUtils.mkdir_p(File.join(target_root_path, 'c', 'c', 'extract_only'))
        FileUtils.mkdir_p(File.join(target_root_path, 'd', 'generated_only', 'extract_only'))
        FileUtils.mkdir_p(File.join(target_root_path, 'e', 'generated_and_extract'))
        FileUtils.mkdir_p(File.join(target_root_path, 'f', 'edge_cases'))

        # Rules for on reset root path. These rules relate to what folders should be left after reset
        # a/b/c                           - no files                          - all folders should be deleted
        # b/generated_only/b              - has generated files               - folder and files should be deleted
        # b/generated_only                -                                   - folder should be deleted
        # b                               -                                   - folder should be deleted
        # c/c/extract_only                - has extracted files               - extracted files should exist, folder should not be deleted
        # c/c                             -                                   - folder should not be deleted
        # c                               -                                   - folder should not be deleted
        # d/generated_only/extract_only   - has extracted files               - extracted files should exist, folder should not be deleted
        # d/generated_only                - has generated files               - generated files should be cleared, folder should not be deleted
        # d/                              -                                   - folder should not be deleted
        # e/generated_and_extract         - has generated and extracted files - generated files should be cleared, extracted files should exist, folder should not be deleted
        # e                               -                                   - folder should not be deleted
        # f/edge_cases/xmen.txt           -                                   - file with extension should not be deleted
        # f/edge_cases/xmen               -                                   - file with no extension should not deleted
        # f/edge_cases/html               -                                   - file with name that looks like an extension should not be deleted

        FileUtils.touch b1_generated
        FileUtils.touch b2_generated
        FileUtils.touch b3_generated
        FileUtils.touch b4_generated

        FileUtils.touch c1_extracted
        FileUtils.touch c2_extracted

        FileUtils.touch d1_extracted
        FileUtils.touch d2_generated

        FileUtils.touch e1_generated
        FileUtils.touch e2_extracted

        FileUtils.touch f1_edge_case
        FileUtils.touch f2_edge_case
        FileUtils.touch f3_edge_case

        instance.generate
      end

      let(:b1_generated) { File.join(target_root_path, 'b', 'generated_only', 'b', GEN_CLEAN_HTML) }
      let(:b2_generated) { File.join(target_root_path, 'b', 'generated_only', 'b', GEN_HTML) }
      let(:b3_generated) { File.join(target_root_path, 'b', 'generated_only', 'b', GEN_SETTINGS) }
      let(:b4_generated) { File.join(target_root_path, 'b', 'generated_only', 'b', GEN_TAILWIND) }

      let(:c1_extracted) { File.join(target_root_path, 'c', 'c', 'extract_only', EXT_DATA) }
      let(:c2_extracted) { File.join(target_root_path, 'c', 'c', 'extract_only', EXT_MODEL) }

      let(:d1_extracted) { File.join(target_root_path, 'd', 'generated_only', 'extract_only', EXT_DATA) }
      let(:d2_generated) { File.join(target_root_path, 'd', 'generated_only', GEN_CLEAN_HTML) }

      let(:e1_generated) { File.join(target_root_path, 'e', 'generated_and_extract', GEN_CLEAN_HTML) }
      let(:e2_extracted) { File.join(target_root_path, 'e', 'generated_and_extract', EXT_DATA) }

      let(:f1_edge_case) { File.join(target_root_path, 'f', 'edge_cases', 'xmen.txt') }
      let(:f2_edge_case) { File.join(target_root_path, 'f', 'edge_cases', 'ymen') }
      let(:f3_edge_case) { File.join(target_root_path, 'f', 'edge_cases', 'html') }

      # Generated files include
      # *.clean.html
      # *.html
      # *.settings.json
      # *.tailwind.config.js

      # Extracted or manually modified files include
      # *.data.json
      # *.model.rb

      context 'when reset_root_path is false' do
        let(:reset_root_path) { false }

        it 'does not delete the content under root path' do
          expect(File.exist?(File.join(target_root_path, 'a', 'b', 'c'))).to be true
        end
      end

      context 'when reset_root_path is true' do
        let(:reset_root_path) { true }

        # c/c/extract_only                - has extracted files               - extracted files should exist, folder should not be deleted
        # c/c                             -                                   - folder should not be deleted
        # c                               -                                   - folder should not be deleted
        # d/generated_only/extract_only   - has extracted files               - extracted files should exist, folder should not be deleted
        # d/generated_only                - has generated files               - generated files should be cleared, folder should not be deleted
        # d/                              -                                   - folder should not be deleted
        # e/generated_and_extract         - has generated and extracted files - generated files should be cleared, extracted files should exist, folder should not be deleted
        # e                               -                                   - folder should not be deleted
        # f/edge_cases/xmen.txt           -                                   - file with extension should not be deleted
        # f/edge_cases/xmen               -                                   - file with no extension should not deleted
        # f/edge_cases/html               -                                   - file with name that looks like an extension should not be deleted
        # f/edge_cases                    -                                   - folder should not be deleted

        it 'deletes any empty folders' do
          expect(Dir.exist?(target_root_path)).to be true
          # a/b/c                           - no files                          - all folders should be deleted
          expect(Dir.exist?(File.join(target_root_path, 'a', 'b', 'c'))).to be false

          # b                               -                                   - folder should be deleted
          expect(Dir.exist?(File.join(target_root_path, 'b'))).to be false

          # c                               -                                   - folder should not be deleted
          expect(Dir.exist?(File.join(target_root_path, 'c', 'c', 'extract_only'))).to be true

          # d/generated_only/extract_only   - has extracted files               - extracted files should exist, folder should not be deleted
          expect(Dir.exist?(File.join(target_root_path, 'd', 'generated_only', 'extract_only'))).to be true

          expect(Dir.exist?(File.join(target_root_path, 'e', 'generated_and_extract'))).to be true
        end

        it 'deletes transient files only' do
          expect(File.exist?(b1_generated)).to be false
          expect(File.exist?(b2_generated)).to be false
          expect(File.exist?(b3_generated)).to be false
          expect(File.exist?(b4_generated)).to be false

          expect(File.exist?(d2_generated)).to be false

          expect(File.exist?(e1_generated)).to be false
        end

        it 'does not delete extracted files or unknown file types' do
          expect(File.exist?(c1_extracted)).to be true
          expect(File.exist?(c2_extracted)).to be true

          expect(File.exist?(d1_extracted)).to be true

          expect(File.exist?(e2_extracted)).to be true

          expect(File.exist?(f1_edge_case)).to be true
          expect(File.exist?(f2_edge_case)).to be true
          expect(File.exist?(f3_edge_case)).to be true
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

      context 'component settings' do
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
