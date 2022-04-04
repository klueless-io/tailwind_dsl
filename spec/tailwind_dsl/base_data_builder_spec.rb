# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TailwindDsl::BaseDataBuilder do
  subject { instance }

  let(:instance) { described_class.new }

  it { is_expected.not_to be_nil }

  context '.obj' do
    subject { instance.obj }

    fit { is_expected.to be_nil }
  end
end
