# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TailwindDsl::Config::Component do
  subject { instance }

  let(:instance) { described_class.new }

  it { is_expected.not_to be_nil }

  context '.key' do
    subject { instance.key }

    fit { is_expected.to be_nil }
  end

  context '.name' do
    subject { instance.name }

    fit { is_expected.to be_nil }
  end

  context '.description' do
    subject { instance.description }

    fit { is_expected.to be_nil }
  end

  context '.data_shape' do
    subject { instance.data_shape }

    fit { is_expected.to be_nil }
  end
end
