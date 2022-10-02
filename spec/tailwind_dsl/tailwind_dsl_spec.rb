# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TailwindDsl::TailwindDsl do
  subject { instance }

  let(:instance) { described_class.new }

  it { is_expected.not_to be_nil }

  context '.website' do
    subject { instance.website }

    it { is_expected.to be_nil }
  end

  context '.page' do
    subject { instance.page }

    it { is_expected.to be_nil }
  end

  context '.component' do
    subject { instance.component }

    it { is_expected.to be_nil }
  end

  context '.save' do
    subject { instance.save }

    it { is_expected.to be_nil }
  end
end
