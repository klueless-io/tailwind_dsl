# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TailwindDsl::Config::Configuration do
  subject { instance }

  let(:instance) { described_class.new }

  it { is_expected.not_to be_nil }

  context '.collections' do
    subject { instance.collections }

    fit { is_expected.to be_nil }
  end

  context '.themes' do
    subject { instance.themes }

    fit { is_expected.to be_nil }
  end

  context '.data_shapes' do
    subject { instance.data_shapes }

    fit { is_expected.to be_nil }
  end

  context '.component_groups' do
    subject { instance.component_groups }

    fit { is_expected.to be_nil }
  end
end
