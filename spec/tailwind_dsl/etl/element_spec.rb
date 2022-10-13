# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TailwindDsl::Etl::Element do
  let(:parent) do
    Class.new(described_class) do
      attr_accessor :first_name
      attr_accessor :last_name
      attr_accessor :items

      def initialize(**args)
        @first_name = grab_arg(args, :first_name, guard: 'Missing first_name')
        @last_name = grab_arg(args, :last_name)
        @items = grab_arg(args, :items, default: %w[item1 item2])
      end
    end
  end

  let(:child) do
    Class.new(described_class) do
      attr_accessor :a
      attr_accessor :b

      def initialize(**args)
        @a = grab_arg(args, :a)
        @b = grab_arg(args, :b)
      end
    end
  end

  describe '#map_to' do
    before { stub_const('Child', child) }

    subject { described_class.new.map_to(Child, data) }

    context 'when data of type Hash is mapped' do
      let(:data) { { a: 'aaa', b: 'bbb' } }

      it { is_expected.to be_a(Child).and have_attributes(a: 'aaa', b: 'bbb') }
    end
  end

  describe '#add_to_list' do
    subject { child_list }

    before do
      stub_const('Child', child)

      described_class.new.add_to_list(Child, child_list, data)
    end

    let(:child_list) { [] }

    context 'when data of type Hash is added to a list' do
      let(:data) { { a: 'aaa', b: 'bbb' } }

      it { is_expected.to all(be_a(Child)).and include(have_attributes(a: 'aaa', b: 'bbb')) }
    end
  end

  describe '#grab_arg' do
    before { stub_const('Parent', parent) }

    subject { Parent.new(**data) }

    context 'when the key is a symbol and value is provided' do
      let(:data) { { first_name: 'John' } }

      it 'accessor is set with value' do
        expect(subject.first_name).to eq('John')
      end
    end

    context 'when the key is a string and value is provided' do
      let(:data) { { 'first_name' => 'John' } }

      it 'accessor is set with value' do
        expect(subject.first_name).to eq('John')
      end
    end

    context 'when the key is required and value is not provided' do
      let(:data) { {} }

      it 'raises an error' do
        expect { subject }.to raise_error('Missing first_name')
      end
    end

    context 'when the key is not required and value is not provided' do
      let(:data) { { first_name: 'John' } }

      it 'accessor is set with default value' do
        expect(subject.last_name).to be_nil
      end
    end

    context 'when the key is not required and default value configured' do
      let(:data) { { first_name: 'John' } }

      it 'accessor is set with default value' do
        expect(subject.items).to eq(%w[item1 item2])
      end
    end
  end
end
