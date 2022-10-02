# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TailwindDsl::Schema::Component do
  subject { instance }

  let(:instance) { described_class.new }

  it { is_expected.not_to be_nil }

  context '.key' do
    subject { instance.key }

    it { is_expected.to be_nil }
  end

  context '.name' do
    subject { instance.name }

    it { is_expected.to be_nil }
  end

  context '.description' do
    subject { instance.description }

    it { is_expected.to be_nil }
  end

  context '.component_group' do
    subject { instance.component_group }

    it { is_expected.to be_nil }
  end

  context '.data_shape' do
    subject { instance.data_shape }

    it { is_expected.to be_nil }
  end
end
