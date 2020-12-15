# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Value::Numeric' do
  shared_examples 'type-casting' do
    specify 'float => float' do
      expect(type.cast(79.1)).to eq(79.1).and be_a(::Float)
    end

    specify 'nil => float' do
      expect(type.cast(nil)).to eq(0.0).and be_a(::Float)
    end

    specify 'string => float' do
      expect(type.cast('test')).to eq(0.0).and(be_a(::Float))
      expect(type.cast('123')).to eq(123.0).and be_a(::Float)
      expect(type.cast('71.28')).to eq(71.28).and be_a(::Float)
      expect(type.cast('123test')).to eq(123.0).and be_a(::Float)
    end

    specify 'integer => integer' do
      expect(type.cast(99)).to eq(99).and be_a(::Integer)
    end

    specify 'bigdecimal => bigdecimal' do
      expect(type.cast(BigDecimal('100.507'))).to eq(BigDecimal('100.507')).and be_a(::BigDecimal)
    end

    specify 'castable => numeric (integer/float/bigdecimal)' do
      value = Class.new { def to_i; 123; end; }.new
      expect(type.cast(value)).to eq(123).and be_a(::Integer)

      value = Class.new { def to_f; 22.0; end; }.new
      expect(type.cast(value)).to eq(22.0).and be_a(::Float)

      value = Class.new { def to_d; BigDecimal('22.10'); end; }.new
      expect(type.cast(value)).to eq(BigDecimal('22.10')).and be_a(::BigDecimal)
    end

    specify 'invalid casting' do
      expect { type.cast(Object.new) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast({}) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast([]) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast(:test) }.to raise_error(SmartCore::Types::TypeCastingError)
    end

    context 'cast priority' do
      specify 'float > all (> integer > bigdecimal)' do
        value = Class.new do
          # rubocop:disable Layout/EmptyLineBetweenDefs
          def to_i; 1; end
          def to_f; 2.0; end
          def to_d; BigDecial('3.0'); end
          # rubocop:enable Layout/EmptyLineBetweenDefs
        end.new
        expect(type.cast(value)).to eq(2.0).and be_a(::Float)
      end

      specify 'integer > bigdecimal' do
        value = Class.new do
          # rubocop:disable Layout/EmptyLineBetweenDefs
          def to_i; 15; end
          def to_d; BigDecial('3.0'); end
          # rubocop:enable Layout/EmptyLineBetweenDefs
        end.new
        expect(type.cast(value)).to eq(15).and be_a(::Integer)
      end
    end
  end

  shared_examples 'type-checking / type-validation (non-nilable)' do
    specify 'type-checking' do
      expect(type.valid?(123)).to eq(true)
      expect(type.valid?(123.567)).to eq(true)
      expect(type.valid?(BigDecimal('123.567'))).to eq(true)
      expect(type.valid?(-Float::INFINITY)).to eq(true)
      expect(type.valid?(Float::INFINITY)).to eq(true)
      expect(type.valid?(Float::NAN)).to eq(true)

      expect(type.valid?(nil)).to eq(false)
      expect(type.valid?('test')).to eq(false)
      expect(type.valid?(:test)).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(123) }.not_to raise_error
      expect { type.validate!(123.567) }.not_to raise_error
      expect { type.validate!(BigDecimal('123.567')) }.not_to raise_error
      expect { type.validate!(-Float::INFINITY) }.not_to raise_error
      expect { type.validate!(Float::INFINITY) }.not_to raise_error
      expect { type.validate!(Float::NAN) }.not_to raise_error

      expect { type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  shared_examples 'type-checking / type-validation (nilable)' do
    specify 'type-checking' do
      expect(type.valid?(123)).to eq(true)
      expect(type.valid?(123.567)).to eq(true)
      expect(type.valid?(BigDecimal('123.567'))).to eq(true)
      expect(type.valid?(-Float::INFINITY)).to eq(true)
      expect(type.valid?(Float::INFINITY)).to eq(true)
      expect(type.valid?(Float::NAN)).to eq(true)
      expect(type.valid?(nil)).to eq(true)

      expect(type.valid?('test')).to eq(false)
      expect(type.valid?(:test)).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(123) }.not_to raise_error
      expect { type.validate!(123.567) }.not_to raise_error
      expect { type.validate!(BigDecimal('123.567')) }.not_to raise_error
      expect { type.validate!(-Float::INFINITY) }.not_to raise_error
      expect { type.validate!(Float::INFINITY) }.not_to raise_error
      expect { type.validate!(Float::NAN) }.not_to raise_error
      expect { type.validate!(nil) }.not_to raise_error

      expect { type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  context 'non-nilable type' do
    let(:type) { SmartCore::Types::Value::Numeric }

    it_behaves_like 'type-casting'
    it_behaves_like 'type-checking / type-validation (non-nilable)'
  end

  context 'runtime-based non-nilable type' do
    let(:type) { SmartCore::Types::Value::Numeric() }

    it_behaves_like 'type-casting'
    it_behaves_like 'type-checking / type-validation (non-nilable)'
  end

  context 'nilable type' do
    let(:type) { SmartCore::Types::Value::Numeric.nilable }

    it_behaves_like 'type-casting'
    it_behaves_like 'type-checking / type-validation (nilable)'
  end

  context 'runtime-based nilable type' do
    let(:type) { SmartCore::Types::Value::Numeric().nilable }

    it_behaves_like 'type-casting'
    it_behaves_like 'type-checking / type-validation (nilable)'
  end

  specify 'has no support for runtime attributes' do
    expect { SmartCore::Types::Value::Numeric(100_500) }.to raise_error(
      SmartCore::Types::RuntimeAttriburtesUnsupportedError
    )
  end
end
