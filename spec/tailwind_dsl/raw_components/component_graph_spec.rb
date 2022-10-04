# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TailwindDsl::RawComponents::ComponentGraph do
  subject { instance }

  let(:instance) { described_class.new }
  let(:component_path) { File.expand_path('../../sample_components', File.dirname(__FILE__)) }

  context 'initialize' do
    it { is_expected.to be_a described_class }

    context '.design_systems' do
      subject { instance.design_systems }
    
      it { is_expected.to be_empty }
    end
  end

  context '#add_design_system' do
    let(:path) { File.join(component_path, name) }
    let(:name) { 'tui' }

    before { instance.add_design_system(path) }

    context '.design_system?' do
      subject { instance.design_system?(name) }

      it { is_expected.to be_truthy }

      context 'with a different name' do
        let(:name) { 'tailwind_ui' }
          
        it { is_expected.to be_truthy }
      end

      context 'when kit name not found' do
        subject { instance.design_system?('bad') }

        it { is_expected.to be_falsey }
      end
    end

    context '#design_system' do
      subject { instance.design_system(name) }

      it { is_expected.to be_a(Hash) }

      it { is_expected.to include(name: name, path: path) }

      # it { puts JSON.pretty_generate(subject.to_h) }
    end
  end

  # context 'examples' do
  #   let(:path) { File.join(component_path, 'tui') }
  #   let(:output_path) { File.expand_path('../../sample_output', File.dirname(__FILE__)) }

  #   before { instance.add_design_system(path) }

  #   context 'sample' do
  #     let(:component_path) { File.expand_path('../../sample_components', File.dirname(__FILE__)) }
  #     it { instance.write(File.join(output_path, 'uikit.sample.json')) }
  #   end

  #   context 'live' do
  #     let(:component_path) { '/Users/davidcruwys/dev/kgems/k_templates/templates/tailwind' }
  #     it { instance.write(File.join(output_path, 'uikit.live.json')) }
  #   end
  # end
end
