# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Value::Set' do
  context 'non-nilable type' do
    let(:type) { SmartCore::Types::Value::Set }

    xspecify 'type-casting'
    xspecify 'type-checking'
    xspecify 'type-validation'
  end

  context 'runtime-based non-nilable type' do
    let(:type) { SmartCore::Types::Value::Set() }

    xspecify 'type-casting'
    xspecify 'type-checking'
    xspecify 'type-validation'
  end

  context 'nilable type' do
    let(:type) { SmartCore::Types::Value::Set.nilable }

    xspecify 'type-casting'
    xspecify 'type-checking'
    xspecify 'type-validation'
  end

  context 'runtime-based nilable type' do
    let(:type) { SmartCore::Types::Value::Set().nilable }

    xspecify 'type-casting'
    xspecify 'type-checking'
    xspecify 'type-validation'
  end

  specify 'has no support for runtime attributes' do
    expect { SmartCore::Types::Value::Set(Set.new([1,2,3])) }.to raise_error(
      SmartCore::Types::RuntimeAttriburtesUnsupportedError
    )
  end
end
