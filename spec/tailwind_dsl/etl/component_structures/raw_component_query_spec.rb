# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TailwindDsl::Etl::ComponentStructures::RawComponentQuery do
  include_context :use_temp_folder

  let(:query) do
    described_class.query(uikit,
                          raw_component_root_path: raw_component_root_path,
                          component_structure_root_path: root_target_path,
                          debug: true)
  end

  let(:design_systems_file) { File.join(SPEC_FOLDER, 'samples/input/uikit.json') }
  let(:design_systems_data) { JSON.parse(File.read(design_systems_file), symbolize_names: true) }
  let(:uikit) { ::TailwindDsl::Etl::RawComponents::UiKit.new(design_systems_data) }

  let(:raw_component_root_path) { File.join(SPEC_FOLDER, 'samples/components') }
  let(:root_target_path) { File.join(temp_folder, 'components') }

  it do
    # puts JSON.pretty_generate(uikit.to_h)
    puts JSON.pretty_generate(query.to_h)
  end

  describe '.to_h' do
    subject { query.to_h }

    it 'has a list of hash with expected data' do
      expect(subject).to be_a(Array)
      expect(subject.first)
        .to include(design_system: include(name: 'tui'))
        .and include(component_group: include(key: 'marketing.section.cta'))
        .and include(absolute_component: include(source_file: end_with('marketing/section/cta/03.html')))
        .and include(relative_component: include(source_file: end_with('marketing/section/cta/03.html')))
    end
  end

  describe '.records' do
    subject { query.records }
    it 'has a records with expected data' do
      expect(subject).to be_a(Array)
      expect(subject.first)
        .to have_attributes(design_system: have_attributes(name: 'tui'))
        .and have_attributes(component_group: have_attributes(key: 'marketing.section.cta'))
        .and have_attributes(absolute_component: have_attributes(source_file: end_with('marketing/section/cta/03.html')))
        .and have_attributes(relative_component: have_attributes(source_file: end_with('marketing/section/cta/03.html')))
    end
  end

  describe '.graph' do
    let(:graph) { query.graph }

    it 'has a graph with expected data' do
      # puts JSON.pretty_generate(graph)
      expect(graph).to be_a(Array)
      expect(graph.first).to include(name: 'tui')
      expect(graph.first[:groups]).to be_a(Array)
      expect(graph.first[:groups].first).to include(key: 'marketing.section.cta')
      expect(graph.first[:groups].first[:files]).to be_a(Array)
      expect(graph.first[:groups].first[:files].first[:relative][:source_file]).not_to be_nil
      expect(graph.first[:groups].first[:files].first[:absolute][:source_file]).not_to be_nil
    end
  end
end
