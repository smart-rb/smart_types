# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Value::BigDecimal' do
  shared_examples 'type casting' do
    specify 'type-casting' do
      expect(type.cast('18491.1823')).to eq(BigDecimal('18491.1823')).and be_a(::BigDecimal)
      expect(type.cast('71')).to eq(BigDecimal('71')).and be_a(::BigDecimal)
      expect(type.cast(9301)).to eq(BigDecimal('9301')).and be_a(::BigDecimal)
      expect(type.cast(81.29)).to eq(BigDecimal('81.29')).and be_a(::BigDecimal)
      expect(type.cast('test')).to eq(BigDecimal('0.0')).and be_a(::BigDecimal)

      as_decimal = Class.new { def to_d; BigDecimal('77.11'); end; }.new
      expect(type.cast(as_decimal)).to eq(BigDecimal('77.11')).and be_a(::BigDecimal)

      expect { type.cast(Object.new) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast([]) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast({}) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast(:test) }.to raise_error(SmartCore::Types::TypeCastingError)
    end
  end

  context 'non-nilable type' do
    let(:type) { SmartCore::Types::Value::BigDecimal }

    include_examples 'type casting'

    specify 'type-checking' do
      expect(type.valid?(BigDecimal('123.456'))).to eq(true)
      expect(type.valid?(BigDecimal('99999999999999999999999999'))).to eq(true)

      expect(type.valid?(nil)).to eq(false)
      expect(type.valid?('123')).to eq(false)
      expect(type.valid?(:test)).to eq(false)
      expect(type.valid?(18483.991238)).to eq(false)
      expect(type.valid?(99999999999)).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?([])).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(BigDecimal('123.456')) }.not_to raise_error
      expect { type.validate!(BigDecimal('99999999999999999999999999')) }.not_to raise_error

      expect { type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('123') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(18483.991238) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(99999999999) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  context 'nilable type' do
    let(:type) { SmartCore::Types::Value::BigDecimal.nilable }

    include_examples 'type casting'

    specify 'type-checking' do
      expect(type.valid?(BigDecimal('123.456'))).to eq(true)
      expect(type.valid?(BigDecimal('99999999999999999999999999'))).to eq(true)
      expect(type.valid?(nil)).to eq(true)

      expect(type.valid?('123')).to eq(false)
      expect(type.valid?(:test)).to eq(false)
      expect(type.valid?(18483.991238)).to eq(false)
      expect(type.valid?(99999999999)).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?([])).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(BigDecimal('123.456')) }.not_to raise_error
      expect { type.validate!(BigDecimal('99999999999999999999999999')) }.not_to raise_error
      expect { type.validate!(nil) }.not_to raise_error

      expect { type.validate!('123') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(18483.991238) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(99999999999) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
    end
  end
end
