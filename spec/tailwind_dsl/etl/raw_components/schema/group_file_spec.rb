# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TailwindDsl::Etl::RawComponents::Group do
  subject { instance.to_h }

  let(:instance) { described_class.new(data) }

  context 'when json/hash used for input' do
    context 'when files excluded' do
      let(:data) { attributes_for(:raw_components_group) }

      it { is_expected.to include(data) }
      it { is_expected.to include(files: []) }
    end

    context 'when files included' do
      let(:data) do
        attributes_for(:raw_components_group)
          .merge(files: [attributes_for(:raw_components_source_file)])
      end

      let(:expected_data) do
        attributes_for(:raw_components_group)
          .merge(files: [attributes_for(:raw_components_source_file)])
      end

      it { is_expected.to include(expected_data) }

      context 'files should contain SourceFile' do
        subject { instance.files.first }

        it { is_expected.to be_a(TailwindDsl::Etl::RawComponents::SourceFile) }
      end
    end
  end

  context 'when json/hash plus typed files for input' do
    subject { instance.to_h }

    let(:data) do
      attributes_for(:raw_components_group)
        .merge(files: [build(:raw_components_source_file)])
    end

    let(:expected_data) do
      attributes_for(:raw_components_group)
        .merge(files: [attributes_for(:raw_components_source_file)])
    end

    context 'when target is not included' do
      it { is_expected.to eq(expected_data) }
    end
  end

  describe '#add_file' do
    before { instance.add_file(file) }

    subject { instance.files.first }

    let(:data) { attributes_for(:raw_components_group) }

    context 'when file is SourceFile' do
      let(:file) { build(:raw_components_source_file) }

      it { is_expected.to be_a(TailwindDsl::Etl::RawComponents::SourceFile) }
      it { expect { instance.add_file(file) }.to change(instance.files, :count).by(1) }
    end

    context 'when file is Hash' do
      let(:file) { attributes_for(:raw_components_source_file) }

      it { is_expected.to be_a(TailwindDsl::Etl::RawComponents::SourceFile) }
      it { expect { instance.add_file(file) }.to change(instance.files, :count).by(1) }
    end

    context 'when file data is invalid' do
      let(:file) { 'some string' }

      it { is_expected.to be_nil }
    end

    context 'when file data is nil' do
      let(:file) { nil }

      it { is_expected.to be_nil }
    end
  end
end
