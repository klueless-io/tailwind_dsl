# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TailwindDsl::Etl::RawComponents::SourceFile do
  subject { instance.to_h }

  let(:instance) { described_class.new(data) }

  context 'when json/hash used for input' do
    context 'when target excluded' do
      let(:data) { attributes_for(:raw_components_source_file) }

      it { is_expected.to include(data) }
      it { expect(subject[:target]).to be_nil }
    end

    context 'when target included' do
      let(:data) do
        attributes_for(:raw_components_source_file)
          .merge(target: attributes_for(:raw_components_target_file))
      end

      it { is_expected.to include(data) }
      it { expect(subject[:target]).to eq(attributes_for(:raw_components_target_file)) }

      context 'target should be TargetFile' do
        subject { instance.target }

        it { is_expected.to be_a(TailwindDsl::Etl::RawComponents::TargetFile) }
      end
    end
  end

  context 'when json/hash plus typed target for input' do
    let(:data) do
      attributes_for(:raw_components_source_file)
        .merge(target: build(:raw_components_target_file))
    end

    let(:expected_data) do
      attributes_for(:raw_components_source_file)
        .merge(target: attributes_for(:raw_components_target_file))
    end

    context 'when target included' do
      it { is_expected.to eq(expected_data) }
    end
  end
end
