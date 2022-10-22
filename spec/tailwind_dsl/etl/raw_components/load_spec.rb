# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TailwindDsl::Etl::RawComponents::Load do
  subject { instance }

  let(:instance) { described_class.new }
  let(:target_root_path) { File.join(SPEC_FOLDER, 'samples/01-raw_components') }

  context 'initialize' do
    it { is_expected.to be_a described_class }

    context '.uikit' do
      subject { instance.uikit }

      it { is_expected.to be_a(::TailwindDsl::Etl::RawComponents::UiKit) }
    end
  end

  context '#add_design_system' do
    let(:path) { File.join(target_root_path, name) }
    let(:name) { 'tui' }

    before { instance.add_design_system(path) }

    context '.uikit' do
      subject { instance.uikit }

      it { is_expected.to be_a(::TailwindDsl::Etl::RawComponents::UiKit) }
    end
  end

  context 'examples' do
    let(:target_root_path) { File.join(SPEC_FOLDER, 'samples/output') }

    context 'sample' do
      before do
        instance.add_design_system(File.join(target_root_path, 'tui'))
        instance.add_design_system(File.join(target_root_path, 'noq'))
      end

      it { instance.write(File.join(target_root_path, 'uikit.sample.json')) }
    end

    context 'live' do
      let(:target_root_path) { File.expand_path('~/dev/kgems/k_templates/templates/tailwind') }

      before do
        instance.add_design_system(File.join(target_root_path, 'tui'))
        instance.add_design_system(File.join(target_root_path, 'noq'))
      end

      it { instance.write(File.join(target_root_path, 'uikit.live.json')) }
    end
  end
end
