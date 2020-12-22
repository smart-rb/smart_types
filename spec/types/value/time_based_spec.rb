# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Value::TimeBased' do
  shared_examples 'type casting' do
    specify 'type-casting' do
      expect(type.cast('2020-05-01')).to eq(Time.new(2020, 5, 1))
      expect(type.cast('20210417')).to eq(Time.new(2021, 4, 17))
      expect(type.cast('3rd Feb 2019')).to eq(Time.new(2019, 2, 3))
      expect(type.cast(946702800)).to eq(Time.new(2000, 1, 1, 8))
      expect(type.cast(Time.new(2010, 10, 31))).to eq(Time.new(2010, 10, 31))
      expect(type.cast(Date.new(2021, 1, 7))).to eq(Date.new(2021, 1, 7)).and be_a(::Date)

      expect(type.cast(DateTime.new(2020, 7, 4, 19, 20, 13)))
        .to eq(DateTime.new(2020, 7, 4, 19, 20, 13))
        .and be_a(::DateTime)

      current_time  = Time.now
      current_year  = current_time.year
      current_month = current_time.month
      current_day   = current_time.day
      expect(type.cast('12:00')).to eq(Time.new(current_year, current_month, current_day, 12))

      expect(type.cast(::Date::Infinity)).to eq(::Date::Infinity)
      expect(type.cast(::DateTime::Infinity)).to eq(::DateTime::Infinity)

      expect { type.cast('2001') }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast(nil) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast(Object.new) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast(BasicObject.new) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast({}) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast([]) }.to raise_error(SmartCore::Types::TypeCastingError)
    end
  end

  shared_examples 'type-checking / type-validation (non-nilable)' do
    specify 'type-checking' do
      expect(type.valid?(Time.new)).to eq(true)
      expect(type.valid?(Date.new)).to eq(true)
      expect(type.valid?(DateTime.new)).to eq(true)
      expect(type.valid?(Date::Infinity)).to eq(true)
      expect(type.valid?(DateTime::Infinity)).to eq(true)

      expect(type.valid?(nil)).to eq(false)
      expect(type.valid?(123)).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?('test')).to eq(false)
      expect(type.valid?(:test)).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?(BasicObject.new)).to eq(false)
      expect(type.valid?([])).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(Time.new) }.not_to raise_error
      expect { type.validate!(Date.new) }.not_to raise_error
      expect { type.validate!(DateTime.new) }.not_to raise_error
      expect { type.validate!(Date::Infinity) }.not_to raise_error
      expect { type.validate!(DateTime::Infinity) }.not_to raise_error

      expect { type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(BasicObject.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  shared_examples 'type-checking / type-validation (nilable)' do
    specify 'type-checking' do
      expect(type.valid?(Time.new)).to eq(true)
      expect(type.valid?(Date.new)).to eq(true)
      expect(type.valid?(DateTime.new)).to eq(true)
      expect(type.valid?(Date::Infinity)).to eq(true)
      expect(type.valid?(DateTime::Infinity)).to eq(true)
      expect(type.valid?(nil)).to eq(true)

      expect(type.valid?(123)).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?('test')).to eq(false)
      expect(type.valid?(:test)).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?(BasicObject.new)).to eq(false)
      expect(type.valid?([])).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(Time.new) }.not_to raise_error
      expect { type.validate!(Date.new) }.not_to raise_error
      expect { type.validate!(DateTime.new) }.not_to raise_error
      expect { type.validate!(Date::Infinity) }.not_to raise_error
      expect { type.validate!(DateTime::Infinity) }.not_to raise_error
      expect { type.validate!(nil) }.not_to raise_error

      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(BasicObject.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  context 'non-nilable type' do
    let(:type) { SmartCore::Types::Value::TimeBased }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (non-nilable)'
  end

  context 'runtime-based non-nilable type' do
    let(:type) { SmartCore::Types::Value::TimeBased() }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (non-nilable)'
  end

  context 'nilable type' do
    let(:type) { SmartCore::Types::Value::TimeBased.nilable }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (nilable)'
  end

  context 'runtime-based nilable type' do
    let(:type) { SmartCore::Types::Value::TimeBased().nilable }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (nilable)'
  end

  specify 'has no support for runtime attributes' do
    expect { SmartCore::Types::Value::TimeBased(Time.new) }.to raise_error(
      SmartCore::Types::RuntimeAttriburtesUnsupportedError
    )

    expect { SmartCore::Types::Value::TimeBased(Date.new) }.to raise_error(
      SmartCore::Types::RuntimeAttriburtesUnsupportedError
    )

    expect { SmartCore::Types::Value::TimeBased(DateTime.new) }.to raise_error(
      SmartCore::Types::RuntimeAttriburtesUnsupportedError
    )
  end
end
