# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TailwindDsl::Transformers::RawComponents::UiKit do
  subject { instance.to_h }

  let(:instance) { described_class.new(data) }

  context 'when json/hash used for input' do
    context 'when data is nil' do
      let(:data) { nil }
      let(:expected_data) { { design_systems: [] } }

      it { is_expected.to include(expected_data) }
    end

    context 'when data is empty hash' do
      let(:data) { {} }
      let(:expected_data) { { design_systems: [] } }

      it { is_expected.to include(expected_data) }
    end

    context 'when design_systems included' do
      let(:data) do
        {
          design_systems: [
            attributes_for(:raw_components_design_system),
            attributes_for(:raw_components_design_system)
          ]
        }
      end

      let(:expected_data) do
        {
          design_systems: [
            attributes_for(:raw_components_design_system).merge(groups: []),
            attributes_for(:raw_components_design_system).merge(groups: [])
          ]
        }
      end

      it { is_expected.to include(expected_data) }
    end
  end

  context 'when typed design_system data is provided for input' do
    subject { instance.to_h }

    let(:data) do
      {
        design_systems: [
          build(:raw_components_design_system),
          build(:raw_components_design_system)
        ]
      }
    end

    let(:expected_data) do
      {
        design_systems: [
          attributes_for(:raw_components_design_system).merge(groups: []),
          attributes_for(:raw_components_design_system).merge(groups: [])
        ]
      }
    end

    it { is_expected.to include(expected_data) }
  end

  describe '#add_design_system' do
    before { instance.add_design_system(design_system) }

    subject { instance.design_systems.first }

    let(:data) { [] }

    context 'when design_system is design_system' do
      let(:design_system) { build(:raw_components_design_system) }

      it { is_expected.to be_a(TailwindDsl::Transformers::RawComponents::DesignSystem) }
      it { expect { instance.add_design_system(design_system) }.to change(instance.design_systems, :count).by(1) }
    end

    context 'when design_system is Hash' do
      let(:design_system) { attributes_for(:raw_components_design_system) }

      it { is_expected.to be_a(TailwindDsl::Transformers::RawComponents::DesignSystem) }
      it { expect { instance.add_design_system(design_system) }.to change(instance.design_systems, :count).by(1) }
    end

    context 'when design_system data is invalid' do
      let(:design_system) { 'some string' }

      it { is_expected.to be_nil }
    end

    context 'when design_system data is nil' do
      let(:design_system) { nil }

      it { is_expected.to be_nil }
    end
  end

  context '.design_system?' do
    subject { instance.design_system?(name) }

    let(:data) do
      {
        design_systems: [
          build(:raw_components_design_system)
        ]
      }
    end

    let(:name) { 'tui' }

    it { is_expected.to be_truthy }

    context 'with a different name' do
      let(:name) { 'tailwind_ui' }

      it { is_expected.to be_falsey }
    end
  end

  context '#design_system' do
    subject { instance.design_system(name) }

    let(:data) do
      {
        design_systems: [
          build(:raw_components_design_system)
        ]
      }
    end

    let(:name) { 'tui' }

    it { is_expected.not_to be_nil }

    context 'with a different name' do
      let(:name) { 'tailwind_ui' }

      it { is_expected.to be_nil }
    end
  end
end
