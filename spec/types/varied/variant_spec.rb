# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Varied::Variant' do
  context 'non-nilable type' do
    let(:type) do
      SmartCore::Types::Varied::Variant.of(
        SmartCore::Types::Value::Integer,
        SmartCore::Types::Value::String,
        SmartCore::Types::Value::Boolean
      )
    end

    specify 'type-checking' do
      expect(type.valid?(10)).to eq(true)
      expect(type.valid?('20')).to eq(true)
      expect(type.valid?(false)).to eq(true)

      expect(type.valid?(nil)).to eq(false)
      expect(type.valid?(:test)).to eq(false)
      expect(type.valid?(18483.991238)).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?([])).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(10) }.not_to raise_error
      expect { type.validate!('20') }.not_to raise_error
      expect { type.validate!(false) }.not_to raise_error

      expect { type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(18483.991238) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  context 'nilable type' do
    let(:type) do
      SmartCore::Types::Varied::Variant.of(
        SmartCore::Types::Value::Integer,
        SmartCore::Types::Value::String,
        SmartCore::Types::Value::Boolean
      ).nilable
    end

    specify 'type-checking' do
      expect(type.valid?(10)).to eq(true)
      expect(type.valid?('20')).to eq(true)
      expect(type.valid?(false)).to eq(true)
      expect(type.valid?(nil)).to eq(true)

      expect(type.valid?(:test)).to eq(false)
      expect(type.valid?(18483.991238)).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?([])).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(10) }.not_to raise_error
      expect { type.validate!('20') }.not_to raise_error
      expect { type.validate!(false) }.not_to raise_error
      expect { type.validate!(nil) }.not_to raise_error

      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(18483.991238) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
    end
  end
end
