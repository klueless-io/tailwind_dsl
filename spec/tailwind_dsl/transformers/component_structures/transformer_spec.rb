# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TailwindDsl::Transformers::ComponentStructures::Transformer do
  include_context :use_temp_folder

  subject { instance }

  let(:design_systems_file) { File.expand_path('sample-design-systems.json', File.dirname(__FILE__)) }
  let(:design_systems_data) { JSON.parse(File.read(design_systems_file), symbolize_names: true) }
  let(:uikit) { ::TailwindDsl::Transformers::RawComponents::UiKit.new(design_systems_data) }

  let(:instance) { described_class.new(graph, root_target_path) }

  let(:component_path) { File.expand_path('../../sample_components', File.dirname(__FILE__)) }

  let(:graph) { TailwindDsl::RawComponents::ComponentGraph.new }

  let(:root_target_path) { File.join(temp_folder, 'components') }

  context 'check mock data' do
    it { expect(uikit.design_systems.length).to be > 0 }
    # fit { puts JSON.pretty_generate(design_systems.to_h) }
  end

  # describe 'initialize' do
  #   it { is_expected.to be_a described_class }

  #   describe '.graph' do
  #     subject { instance.graph }

  #     it { is_expected.to be graph }
  #   end

  #   describe '.root_target_path' do
  #     subject { instance.root_target_path }

  #     it { is_expected.to be root_target_path }
  #   end
  # end

  # describe '#generate' do
  #   context 'when target path does not exist' do
  #     let(:root_target_path) { File.join(temp_folder, 'bad') }

  #     it 'raises an error' do
  #       expect { instance.generate }.to raise_error('Target path does not exist')
  #     end
  #   end

  #   context 'when resetting root path' do
  #     let(:instance) { described_class.new(graph, root_target_path, reset_root_path: reset_root_path) }

  #     before do
  #       FileUtils.mkdir_p(File.join(root_target_path, 'a', 'b', 'c'))

  #       graph.add_design_system(File.join(component_path, 'tui'))

  #       instance.generate
  #     end

  #     context 'when reset_root_path is false' do
  #       let(:reset_root_path) { false }

  #       it 'does not delete the content under root path' do
  #         expect(File.exist?(File.join(root_target_path, 'a', 'b', 'c'))).to be true
  #       end
  #     end

  #     context 'when reset_root_path is true' do
  #       let(:reset_root_path) { true }

  #       it 'deletes the content under root path' do
  #         expect(File.exist?(File.join(root_target_path, 'a', 'b', 'c'))).to be false
  #       end
  #     end
  #   end

  #   context 'when target path exists and #generate' do
  #     before do
  #       FileUtils.mkdir_p(root_target_path)

  #       graph.add_design_system(File.join(component_path, 'tui'))

  #       instance.generate
  #     end

  #     let(:cta_folder) { 'tui/marketing/section/cta' }
  #     let(:cta_component) { "#{cta_folder}/01" }
  #     let(:cta_html) { "#{cta_component}.html" }
  #     let(:cta_clean_html) { "#{cta_component}.clean.html" }
  #     let(:cta_tailwind_config) { "#{cta_component}.tailwind.config.js" }
  #     let(:cta_settings) { "#{cta_component}.settings.json" }
  #     let(:cta_data) { "#{cta_component}.data.json" }
  #     let(:cta_astro) { "#{cta_component}.astro" }

  #     context 'design system folder is created' do
  #       it { expect(File.exist?(File.join(root_target_path, 'tui'))).to be_truthy }
  #     end

  #     context 'component sub folder is created' do
  #       it { expect(File.exist?(File.join(root_target_path, cta_folder))).to be true }
  #     end

  #     context 'component html' do
  #       let(:file) { File.join(root_target_path, cta_html) }
  #       let(:content) { File.read(file) }

  #       it 'creates a file' do
  #         expect(File.exist?(file)).to be_truthy
  #       end

  #       it 'has the original content comments' do
  #         expect(content).to include('<!--').and include('This example requires some changes to your config:')
  #       end

  #       it 'has the original blank lines' do
  #         expect(content).to include("<h1>\n  \n</h1>")
  #       end
  #     end

  #     context 'component html (cleaned)' do
  #       let(:file) { File.join(root_target_path, cta_clean_html) }
  #       let(:content) { File.read(file) }

  #       it 'creates a file' do
  #         expect(File.exist?(file)).to be_truthy
  #       end

  #       it 'comments are left unaltered' do
  #         expect(content).not_to include('<!--')
  #         expect(content).not_to include('This example requires some changes to your config:')
  #       end

  #       it 'blank lines are kept' do
  #         expect(content).not_to include("<h1>\n  \n</h1>")
  #       end
  #     end

  #     context 'component tailwind config' do
  #       let(:file) { File.join(root_target_path, cta_tailwind_config) }
  #       let(:content) { File.read(file) }

  #       context 'when the component has a tailwind config' do
  #         it 'creates a file' do
  #           expect(File.exist?(file)).to be_truthy
  #         end

  #         it 'has content' do
  #           expect(content).to include("require('@tailwindcss/aspect-ratio')")
  #         end
  #       end

  #       context 'when the component does not have a tailwind config' do
  #         let(:cta_component) { "#{cta_folder}/03" }

  #         it 'creates a file' do
  #           expect(File.exist?(file)).to be_falsey
  #         end
  #       end
  #     end

  #     context 'component settings' do
  #       let(:file) { File.join(root_target_path, cta_settings) }
  #       let(:settings) { JSON.parse(File.read(file)) }

  #       it 'creates a file' do
  #         expect(File.exist?(file)).to be_truthy
  #       end

  #       it 'has the expected content' do
  #         expect(settings.dig('tailwind_config', 'plugins', 'forms')).to be_falsey
  #         expect(settings.dig('tailwind_config', 'plugins', 'aspect_ratio')).to be_truthy
  #         expect(settings.dig('tailwind_config', 'plugins', 'line_clamp')).to be_falsey
  #         expect(settings.dig('tailwind_config', 'plugins', 'typography')).to be_falsey
  #       end

  #       context 'when the component has all settings' do
  #         let(:cta_component) { "#{cta_folder}/02" }
  #         it 'has the expected content' do
  #           expect(settings.dig('tailwind_config', 'plugins', 'forms')).to be_truthy
  #           expect(settings.dig('tailwind_config', 'plugins', 'aspect_ratio')).to be_truthy
  #           expect(settings.dig('tailwind_config', 'plugins', 'line_clamp')).to be_truthy
  #           expect(settings.dig('tailwind_config', 'plugins', 'typography')).to be_truthy
  #         end
  #       end

  #       context 'when the component has no settings' do
  #         let(:cta_component) { "#{cta_folder}/03" }
  #         it 'has the expected content' do
  #           expect(settings.dig('tailwind_config', 'plugins', 'forms')).to be_falsey
  #           expect(settings.dig('tailwind_config', 'plugins', 'aspect_ratio')).to be_falsey
  #           expect(settings.dig('tailwind_config', 'plugins', 'line_clamp')).to be_falsey
  #           expect(settings.dig('tailwind_config', 'plugins', 'typography')).to be_falsey
  #         end
  #       end
  #     end
  #   end
  # end
end
