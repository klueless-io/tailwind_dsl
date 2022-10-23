# frozen_string_literal: true

require 'spec_helper'

class SampleExtractor < TailwindDsl::Etl::Extractors::BaseExtractor
  def target_file
    'some file'
  end

  def extract
  end
end

RSpec.describe TailwindDsl::Etl::Extractors::BaseExtractor do
  subject { instance }

  let(:instance) { described_class.new }

  context 'initialize' do
    it { is_expected.to be_a described_class }

    context '.component' do
      subject { instance.component }

      it { is_expected.to be_nil }
    end

    context '.target_file' do
      subject { instance.target_file }

      it { expect { subject }.to raise_error(NotImplementedError) }
    end

    context '.extract' do
      subject { instance.extract }

      it { expect { subject }.to raise_error(NotImplementedError) }
    end
  end

  describe SampleExtractor do
    subject { instance }

    context '.target_file' do
      it { expect(subject).to respond_to(:target_file) }
    end

    context '.extract' do
      it { expect(subject).to respond_to(:extract) }
    end
  end
end
