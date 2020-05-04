# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Value::Time' do
  shared_examples 'type casting' do
    specify 'type-casting' do
      expect(type.cast('2010-10-31')).to eq(Time.new(2010, 10, 31))
      expect(type.cast(Time.new(2010, 10, 31))).to eq(Time.new(2010, 10, 31))
      expect(type.cast(946702800)).to eq(Time.new(2000, 1, 1, 8))

      current_time  = Time.now
      current_year  = current_time.year
      current_month = current_time.month
      current_day   = current_time.day
      expect(type.cast('12:00')).to eq(Time.new(current_year, current_month, current_day, 12))

      expect { type.cast('2001') }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast(nil) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast(Object.new) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast({}) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast([]) }.to raise_error(SmartCore::Types::TypeCastingError)
    end
  end

  context 'non-nilable type' do
    let(:type) { SmartCore::Types::Value::Time }

    include_examples 'type casting'

    specify 'type-checking' do
      expect(type.valid?(Time.now)).to eq(true)

      expect(type.valid?(nil)).to eq(false)
      expect(type.valid?(Date.new)).to eq(false)
      expect(type.valid?(DateTime.new)).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?([])).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?(123.456)).to eq(false)
      expect(type.valid?('2010-10-31')).to eq(false)
      expect(type.valid?(:time)).to eq(false)
    end

    specify 'type-casting' do
      expect { type.validate!(Time.now) }.not_to raise_error

      expect { type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Date.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(DateTime.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123.456) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('2010-10-31') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:time) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  context 'nilable type' do
    let(:type) { SmartCore::Types::Value::Time.nilable }

    include_examples 'type casting'

    specify 'type-checking' do
      expect(type.valid?(Time.now)).to eq(true)
      expect(type.valid?(nil)).to eq(true)

      expect(type.valid?(Date.new)).to eq(false)
      expect(type.valid?(DateTime.new)).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?([])).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?(123.456)).to eq(false)
      expect(type.valid?('2010-10-31')).to eq(false)
      expect(type.valid?(:time)).to eq(false)
    end

    specify 'type-casting' do
      expect { type.validate!(Time.now) }.not_to raise_error
      expect { type.validate!(nil) }.not_to raise_error

      expect { type.validate!(Date.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(DateTime.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123.456) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('2010-10-31') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:time) }.to raise_error(SmartCore::Types::TypeError)
    end
  end
end
