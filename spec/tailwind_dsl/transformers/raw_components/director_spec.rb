# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TailwindDsl::Transformers::RawComponents::Director do
  subject { instance }

  let(:instance) { described_class.new }
  let(:component_path) { File.expand_path('../../../sample/components', File.dirname(__FILE__)) }

  context 'initialize' do
    it { is_expected.to be_a described_class }

    context '.uikit' do
      subject { instance.uikit }

      it { is_expected.to be_a(::TailwindDsl::Transformers::RawComponents::UiKit) }
    end
  end

  context '#add_design_system' do
    let(:path) { File.join(component_path, name) }
    let(:name) { 'tui' }

    before { instance.add_design_system(path) }

    context '.uikit' do
      subject { instance.uikit }

      it { is_expected.to be_a(::TailwindDsl::Transformers::RawComponents::UiKit) }
    end
  end

  # context 'examples' do
  #   let(:output_path) { File.expand_path('../../../sample_output', File.dirname(__FILE__)) }

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
