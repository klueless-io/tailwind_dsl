# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TailwindDsl::Etl::RawComponents::DesignSystem do
  subject { instance.to_h }

  let(:instance) { described_class.new(data) }

  context 'when json/hash used for input' do
    context 'when groups excluded' do
      let(:data) { attributes_for(:raw_components_design_system) }

      it { is_expected.to include(data) }
      it { is_expected.to include(groups: []) }
    end

    context 'when groups included' do
      let(:data) do
        attributes_for(:raw_components_design_system)
          .merge(groups: [attributes_for(:raw_components_group)])
      end

      let(:expected_data) do
        attributes_for(:raw_components_design_system)
          .merge(groups: [attributes_for(:raw_components_group).merge(files: [])])
      end

      it { is_expected.to include(expected_data) }
    end
  end

  context 'when json/hash plus typed groups for input' do
    subject { instance.to_h }

    let(:data) do
      attributes_for(:raw_components_design_system)
        .merge(groups: [build(:raw_components_group)])
    end

    let(:expected_data) do
      attributes_for(:raw_components_design_system)
        .merge(groups: [attributes_for(:raw_components_group).merge(files: [])])
    end

    context 'when target is not included' do
      it { is_expected.to eq(expected_data) }
    end
  end

  fdescribe '#add_group' do
    before { instance.add_group(group) }

    subject { instance.groups.first }

    let(:data) { attributes_for(:raw_components_design_system) }

    context 'when group is Group' do
      let(:group) { build(:raw_components_group) }

      it { is_expected.to be_a(TailwindDsl::Etl::RawComponents::Group) }
      it { expect { instance.add_group(group) }.to change(instance.groups, :count).by(1) }
    end

    context 'when group is Hash' do
      let(:group) { attributes_for(:raw_components_group) }

      it { is_expected.to be_a(TailwindDsl::Etl::RawComponents::Group) }
      it { expect { instance.add_group(group) }.to change(instance.groups, :count).by(1) }
    end

    context 'when group data is invalid' do
      let(:group) { 'some string' }

      it { is_expected.to be_nil }
    end

    context 'when group data is nil' do
      let(:group) { nil }

      it { is_expected.to be_nil }
    end
  end
end
