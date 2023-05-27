# frozen_string_literal: true

# rubocop:disable Layout/SpaceAroundOperators
RSpec.describe 'SmartCore::Types::Value::Rational' do
  shared_examples 'type casting' do
    specify 'type-casting' do
      expect(type.cast(123)).to eq(Rational(123/1)).and be_a(::Rational)
      expect(type.cast(3.to_r)).to eq(Rational(3/1)).and be_a(::Rational)
      expect(type.cast(2/3r)).to eq(Rational('2/3')).and be_a(::Rational)
      expect(type.cast(0.3)).to eq(Rational(0.3)).and be_a(::Rational)
      expect(type.cast('0.3')).to eq(Rational('3/10')).and be_a(::Rational)
      expect(type.cast('2/3')).to eq(Rational('2/3')).and be_a(::Rational)

      rationalizable_1 = Class.new { def to_r; Rational(1); end }.new
      rationalizable_2 = Class.new { def to_r; Rational(0.3); end }.new
      expect(type.cast(rationalizable_1)).to eq(Rational(1)).and be_a(::Rational)
      expect(type.cast(rationalizable_2)).to eq(Rational(0.3)).and be_a(::Rational)

      non_rationalizable = Class.new { def to_r; :test; end }.new
      expect { type.cast(non_rationalizable) }.to raise_error(SmartCore::Types::TypeCastingError)

      expect { type.cast(-Float::INFINITY) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast(Float::INFINITY) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast(Float::NAN) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast(nil) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast([]) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast({}) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast(Object.new) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast(BasicObject.new) }.to raise_error(SmartCore::Types::TypeCastingError)
    end
  end

  shared_examples 'type-checking / type-validation (non-nilable)' do
    specify 'type-checking' do
      expect(type.valid?(123.to_r)).to eq(true)
      expect(type.valid?(3.to_r)).to eq(true)
      expect(type.valid?(2/3r)).to eq(true)
      expect(type.valid?(0.3.to_r)).to eq(true)
      expect(type.valid?('0.3'.to_r)).to eq(true)
      expect(type.valid?('2/3'.to_r)).to eq(true)

      expect(type.valid?(Rational(123/1))).to eq(true)
      expect(type.valid?(Rational(3/1))).to eq(true)
      expect(type.valid?(Rational('2/3'))).to eq(true)
      expect(type.valid?(Rational(0.3))).to eq(true)
      expect(type.valid?(Rational('3/10'))).to eq(true)
      expect(type.valid?(Rational('2/3'))).to eq(true)

      expect(type.valid?(-Float::INFINITY)).to eq(false)
      expect(type.valid?(Float::INFINITY)).to eq(false)
      expect(type.valid?(Float::NAN)).to eq(false)
      expect(type.valid?(nil)).to eq(false)
      expect(type.valid?([])).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?(BasicObject.new)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(123.to_r) }.not_to raise_error
      expect { type.validate!(3.to_r) }.not_to raise_error
      expect { type.validate!(2/3r) }.not_to raise_error
      expect { type.validate!(0.3.to_r) }.not_to raise_error
      expect { type.validate!('0.3'.to_r) }.not_to raise_error
      expect { type.validate!('2/3'.to_r) }.not_to raise_error

      expect { type.validate!(Rational(123/1)) }.not_to raise_error
      expect { type.validate!(Rational(3/1)) }.not_to raise_error
      expect { type.validate!(Rational('2/3')) }.not_to raise_error
      expect { type.validate!(Rational(0.3)) }.not_to raise_error
      expect { type.validate!(Rational('3/10')) }.not_to raise_error
      expect { type.validate!(Rational('2/3')) }.not_to raise_error

      expect { type.validate!(-Float::INFINITY) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Float::INFINITY) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Float::NAN) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(BasicObject.new) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  shared_examples 'type-checking / type-validation (nilable)' do
    specify 'type-checking' do
      expect(type.valid?(123.to_r)).to eq(true)
      expect(type.valid?(3.to_r)).to eq(true)
      expect(type.valid?(2/3r)).to eq(true)
      expect(type.valid?(0.3.to_r)).to eq(true)
      expect(type.valid?('0.3'.to_r)).to eq(true)
      expect(type.valid?('2/3'.to_r)).to eq(true)
      expect(type.valid?(nil)).to eq(true)

      expect(type.valid?(Rational(123/1))).to eq(true)
      expect(type.valid?(Rational(3/1))).to eq(true)
      expect(type.valid?(Rational('2/3'))).to eq(true)
      expect(type.valid?(Rational(0.3))).to eq(true)
      expect(type.valid?(Rational('3/10'))).to eq(true)
      expect(type.valid?(Rational('2/3'))).to eq(true)

      expect(type.valid?(-Float::INFINITY)).to eq(false)
      expect(type.valid?(Float::INFINITY)).to eq(false)
      expect(type.valid?(Float::NAN)).to eq(false)
      expect(type.valid?([])).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?(BasicObject.new)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(123.to_r) }.not_to raise_error
      expect { type.validate!(3.to_r) }.not_to raise_error
      expect { type.validate!(2/3r) }.not_to raise_error
      expect { type.validate!(0.3.to_r) }.not_to raise_error
      expect { type.validate!('0.3'.to_r) }.not_to raise_error
      expect { type.validate!('2/3'.to_r) }.not_to raise_error
      expect { type.validate!(nil) }.not_to raise_error

      expect { type.validate!(Rational(123/1)) }.not_to raise_error
      expect { type.validate!(Rational(3/1)) }.not_to raise_error
      expect { type.validate!(Rational('2/3')) }.not_to raise_error
      expect { type.validate!(Rational(0.3)) }.not_to raise_error
      expect { type.validate!(Rational('3/10')) }.not_to raise_error
      expect { type.validate!(Rational('2/3')) }.not_to raise_error

      expect { type.validate!(-Float::INFINITY) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Float::INFINITY) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Float::NAN) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(BasicObject.new) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  context 'non-nilable type' do
    let(:type) { SmartCore::Types::Value::Rational }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (non-nilable)'
  end

  context 'runtime-based non-nilable type' do
    let(:type) { SmartCore::Types::Value::Rational() }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (non-nilable)'
  end

  context 'nilable type' do
    let(:type) { SmartCore::Types::Value::Rational.nilable }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (nilable)'
  end

  context 'runtime-based nilable type' do
    let(:type) { SmartCore::Types::Value::Rational().nilable }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (nilable)'
  end

  specify 'has no support for runtime attributes' do
    expect { SmartCore::Types::Value::Rational(2/3r) }.to raise_error(
      SmartCore::Types::RuntimeAttriburtesUnsupportedError
    )
  end
end
# rubocop:enable Layout/SpaceAroundOperators
