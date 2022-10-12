# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TailwindDsl::Etl::RawComponents::TargetFile do
  subject { instance }

  let(:instance) { described_class.new(data) }

  context 'when json/hash used for input' do
    let(:data) { attributes_for(:raw_components_target_file) }

    it { is_expected.to have_attributes(data) }
  end
end
