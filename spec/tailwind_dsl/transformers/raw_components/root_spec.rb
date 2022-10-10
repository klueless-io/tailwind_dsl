# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TailwindDsl::Transformers::RawComponents::Root do
  subject { instance }

  let(:instance) { described_class.new(data) }

  let(:data) { FactoryBot.build(:raw_components_root_hash) }

  describe '#to_h' do
    subject { instance.to_h }

    it { is_expected.to eq(data) }
  end
end
