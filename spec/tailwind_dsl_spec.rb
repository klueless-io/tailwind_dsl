# frozen_string_literal: true

RSpec.describe TailwindDsl do
  it 'has a version number' do
    expect(TailwindDsl::VERSION).not_to be nil
  end

  it 'has a standard error' do
    expect { raise TailwindDsl::Error, 'some message' }
      .to raise_error('some message')
  end
end
