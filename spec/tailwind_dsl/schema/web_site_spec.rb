# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TailwindDsl::Schema::WebSite do
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

  context '.target_folder' do
    subject { instance.target_folder }

    fit { is_expected.to be_nil }
  end

  context '.base_collection' do
    subject { instance.base_collection }

    fit { is_expected.to be_nil }
  end

  context '.theme' do
    subject { instance.theme }

    fit { is_expected.to be_nil }
  end

  context '.root' do
    subject { instance.root }

    fit { is_expected.to be_nil }
  end

  context '.favourite_components' do
    subject { instance.favourite_components }

    fit { is_expected.to be_nil }
  end
end
