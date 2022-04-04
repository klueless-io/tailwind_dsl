# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TailwindDsl::Config::Collection do
  subject { instance }

  let(:instance) { described_class.new }

  it { is_expected.not_to be_nil }

  context '.name' do
    subject { instance.name }

    fit { is_expected.to be_nil }
  end

  context '.description' do
    subject { instance.description }

    fit { is_expected.to be_nil }
  end

  context '.component_groups' do
    subject { instance.component_groups }

    fit { is_expected.to be_nil }
  end

  context '.default_themes' do
    subject { instance.default_themes }

    fit { is_expected.to be_nil }
  end
end
