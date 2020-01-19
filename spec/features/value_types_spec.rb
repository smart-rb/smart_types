# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Value types' do
  describe 'Text' do
    specify 'type-checking' do
      expect(SmartCore::Types::Value::Text.valid?('test')).to eq(true)
      expect(SmartCore::Types::Value::Text.valid?(:test)).to eq(true)
      expect(SmartCore::Types::Value::Text.valid?(123)).to eq(false)
      expect(SmartCore::Types::Value::Text.valid?(Object.new)).to eq(false)
    end

    specify 'nilable type-checking' do
      expect(SmartCore::Types::Value::Text.nilable.valid?('test')).to eq(true)
      expect(SmartCore::Types::Value::Text.nilable.valid?(:test)).to eq(true)
      expect(SmartCore::Types::Value::Text.nilable.valid?(123)).to eq(false)
      expect(SmartCore::Types::Value::Text.nilable.valid?(Object.new)).to eq(false)

      expect(SmartCore::Types::Value::Text.nilable.valid?(nil)).to eq(true)
    end

    specify 'type-casting' do
      expect(SmartCore::Types::Value::Text.cast('test')).to eq('test')
      expect(SmartCore::Types::Value::Text.cast(:test)).to eq('test')
      expect(SmartCore::Types::Value::Text.cast([])).to eq('[]')
      expect(SmartCore::Types::Value::Text.cast({})).to eq('{}')
    end
  end
end
