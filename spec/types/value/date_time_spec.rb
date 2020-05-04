# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Value::DateTime' do
  shared_examples 'type casting' do
    specify 'type casting' do
      expect(type.cast('2001-02-03T04:05:06+07:00'))
        .to eq(DateTime.new(2001, 2, 3, 4, 5, 6, '+7'))
        .and be_a(::DateTime)

      expect(type.cast('20010203T040506+0700'))
        .to eq(DateTime.new(2001, 2, 3, 4, 5, 6, '+7'))
        .and be_a(::DateTime)

      expect(type.cast('3rd Feb 2001 04:05:06 PM'))
        .to eq(DateTime.new(2001, 2, 3, 16, 5, 6))
        .and be_a(::DateTime)

      expect(type.cast(DateTime.new(2020, 7, 4, 19, 20, 13)))
        .to eq(DateTime.new(2020, 7, 4, 19, 20, 13))
        .and be_a(::DateTime)

      expect(type.cast(::DateTime::Infinity)).to eq(::DateTime::Infinity)
      expect(type.cast(::Date::Infinity)).to eq(::Date::Infinity)

      expect { type.cast('2001') }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast(nil) }.to raise_error(SmartCore::Types::TypeCastingError)
    end
  end

  context 'non-nilable type' do
    let(:type) { SmartCore::Types::Value::DateTime }

    include_examples 'type casting'

    specify 'type-checking' do
      expect(type.valid?(DateTime.new)).to eq(true)
      expect(type.valid?(DateTime::Infinity)).to eq(true)
      expect(type.valid?(Date::Infinity)).to eq(true)

      expect(type.valid?(Date.new)).to eq(false)
      expect(type.valid?(nil)).to eq(false)
      expect(type.valid?(Time.new)).to eq(false)
      expect(type.valid?(123)).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?('test')).to eq(false)
      expect(type.valid?(:test)).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?([])).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(DateTime.new) }.not_to raise_error
      expect { type.validate!(DateTime::Infinity) }.not_to raise_error
      expect { type.validate!(Date::Infinity) }.not_to raise_error

      expect { type.validate!(Date.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Time.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  context 'nilable type' do
    let(:type) { SmartCore::Types::Value::DateTime.nilable }

    include_examples 'type casting'

    specify 'type-checking' do
      expect(type.valid?(DateTime.new)).to eq(true)
      expect(type.valid?(DateTime::Infinity)).to eq(true)
      expect(type.valid?(Date::Infinity)).to eq(true)
      expect(type.valid?(nil)).to eq(true)

      expect(type.valid?(Date.new)).to eq(false)
      expect(type.valid?(Time.new)).to eq(false)
      expect(type.valid?(123)).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?('test')).to eq(false)
      expect(type.valid?(:test)).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?([])).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(DateTime.new) }.not_to raise_error
      expect { type.validate!(DateTime::Infinity) }.not_to raise_error
      expect { type.validate!(Date::Infinity) }.not_to raise_error
      expect { type.validate!(nil) }.not_to raise_error

      expect { type.validate!(Date.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Time.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
    end
  end
end
