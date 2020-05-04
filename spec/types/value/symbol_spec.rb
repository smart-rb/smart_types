# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Value::Symbol' do
  shared_examples 'type casting' do
    specify 'type-casting' do
      expect(type.cast('cast')).to eq(:cast)
      expect(type.cast(:kek)).to eq(:kek)

      expect { type.cast(Class.new) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast(123) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast({}) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast([]) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast(Object.new) }.to raise_error(SmartCore::Types::TypeCastingError)
    end
  end

  context 'non-nilable type' do
    let(:type) { SmartCore::Types::Value::Symbol }

    include_examples 'type casting'

    specify 'type-checking' do
      expect(type.valid?(:meta)).to eq(true)

      expect(type.valid?(nil)).to eq(false)
      expect(type.valid?('test')).to eq(false)
      expect(type.valid?(true)).to eq(false)
      expect(type.valid?(false)).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?([])).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?(123)).to eq(false)
      expect(type.valid?(123.456)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(:meta) }.not_to raise_error

      expect { type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(true) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(false) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123.456) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  context 'nilable type' do
    let(:type) { SmartCore::Types::Value::Symbol.nilable }

    include_examples 'type casting'

    specify 'type-checking' do
      expect(type.valid?(:meta)).to eq(true)
      expect(type.valid?(nil)).to eq(true)

      expect(type.valid?('test')).to eq(false)
      expect(type.valid?(true)).to eq(false)
      expect(type.valid?(false)).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?([])).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?(123)).to eq(false)
      expect(type.valid?(123.456)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(:meta) }.not_to raise_error
      expect { type.validate!(nil) }.not_to raise_error

      expect { type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(true) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(false) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123.456) }.to raise_error(SmartCore::Types::TypeError)
    end
  end
end
