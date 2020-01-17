# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Value types' do
  describe 'Text' do
    specify 'validation' do
      expect(SmartCore::Types::Value::Text.valid?('test')).to eq(true)
      expect(SmartCore::Types::Value::Text.valid?(:test)).to eq(true)
      expect(SmartCore::Types::Value::Text.valid?(123)).to eq(false)
      expect(SmartCore::Types::Value::Text.valid?(Object.new)).to eq(false)
    end

    specify 'type-casting' do
      expect(SmartCore::Types::Value::Text.cast('test')).to eq('test')
      expect(SmartCore::Types::Value::Text.cast(:test)).to eq('test')
      expect(SmartCore::Types::Value::Text.cast([])).to eq('[]')
      expect(SmartCore::Types::Value::Text.cast({})).to eq('{}')
    end
  end
end
