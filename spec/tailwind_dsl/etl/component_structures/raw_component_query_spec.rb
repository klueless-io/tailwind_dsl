# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TailwindDsl::Etl::ComponentStructures::RawComponentQuery do
  include_context :use_temp_folder
  include_context :get_uikit

  let(:query) do
    described_class.query(uikit,
                          source_root_path: raw_component_root_path,
                          target_root_path: component_structure_root_path)
  end

  let(:raw_component_root_path) { File.join(SPEC_FOLDER, 'samples/components') }
  let(:component_structure_root_path) { File.join(temp_folder, 'components') }

  # it do
  #   # puts JSON.pretty_generate(uikit.to_h)
  #   puts JSON.pretty_generate(query.to_h)
  # end

  describe '.to_h' do
    subject { query.to_h }

    it 'has a list of hash with expected data' do
      expect(subject).to be_a(Array)
      expect(subject.first)
        .to include(name: '03')
        .and include(design_system: include(name: 'tui'))
        .and include(group: include(key: 'marketing.section.cta'))
        .and include(absolute: include(source_file: end_with('marketing/section/cta/03.html')))
        .and include(relative: include(source_file: end_with('marketing/section/cta/03.html')))
    end
  end

  describe '.components' do
    subject { query.components }
    it 'has a components with expected data' do
      expect(subject).to be_a(Array)
      expect(subject.first)
        .to have_attributes(name: '03')
        .and have_attributes(design_system: have_attributes(name: 'tui'))
        .and have_attributes(group: have_attributes(key: 'marketing.section.cta'))
        .and have_attributes(absolute: have_attributes(source_file: end_with('marketing/section/cta/03.html')))
        .and have_attributes(relative: have_attributes(source_file: end_with('marketing/section/cta/03.html')))
    end
  end
end
