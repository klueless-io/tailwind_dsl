# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TailwindDsl::Schema::Page do
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

  context '.sub_folder' do
    subject { instance.sub_folder }

    it { is_expected.to be_nil }
  end

  context '.level' do
    subject { instance.level }

    it { is_expected.to be_nil }
  end

  context '.pages' do
    subject { instance.pages }

    it { is_expected.to be_nil }
  end

  context '.components' do
    subject { instance.components }

    it { is_expected.to be_nil }
  end
end
