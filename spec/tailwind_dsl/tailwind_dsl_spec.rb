# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TailwindDsl::TailwindDsl do
  subject { instance }

  let(:instance) { described_class.new }

  it { is_expected.not_to be_nil }

  context '.website' do
    subject { instance.website }

    fit { is_expected.to be_nil }
  end

  context '.page' do
    subject { instance.page }

    fit { is_expected.to be_nil }
  end

  context '.component' do
    subject { instance.component }

    fit { is_expected.to be_nil }
  end

  context '.save' do
    subject { instance.save }

    fit { is_expected.to be_nil }
  end
end
