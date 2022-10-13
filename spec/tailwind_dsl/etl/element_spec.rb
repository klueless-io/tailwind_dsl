# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TailwindDsl::Etl::Element do
  let(:instance) { described_class.new(data) }

  let(:some_data_object) do
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

  describe '#grab_arg' do
    before { stub_const('SomeDataObject', some_data_object) }

    subject { SomeDataObject.new(**data) }

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
