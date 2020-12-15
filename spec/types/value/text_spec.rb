# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Value::Text' do
  shared_examples 'type-casting' do
    specify 'string => string' do
      expect(type.cast('test')).to eq('test')
      expect(type.cast([])).to eq('[]')
      expect(type.cast({})).to eq('{}')
    end

    specify 'symbol => symbol' do
      expect(type.cast(:test)).to eq(:test)
      expect(type.cast(:notest)).to eq(:notest)
    end

    specify 'castable => string/symbol' do
      castable = Class.new { def to_s; 'kekpek'; end }.new
      expect(type.cast(castable)).to eq('kekpek')

      castable = Class.new do
        undef_method :to_s
        def to_sym; :middle; end
      end.new
      expect(type.cast(castable)).to eq(:middle)
    end

    specify 'invalid casting' do
      non_castable = Class.new { undef_method :to_s; }.new
      expect { type.cast(non_castable) }.to raise_error(SmartCore::Types::TypeCastingError)

      non_castable = Class.new { def to_s; 123; end; }.new
      expect { type.cast(non_castable) }.to raise_error(SmartCore::Types::TypeCastingError)
    end

    specify 'cast priority (string > symbol)' do
      castable = Class.new do
        # rubocop:disable Layout/EmptyLineBetweenDefs
        def to_s; 'as_string'; end
        def to_sym; :as_sym; end
        # rubocop:enable Layout/EmptyLineBetweenDefs
      end.new
      expect(type.cast(castable)).to eq('as_string')
    end
  end

  shared_examples 'type-checking / type-validation (non-nilable)' do
    specify 'type-checking' do
      expect(type.valid?('test')).to eq(true)
      expect(type.valid?(:test)).to eq(true)

      expect(type.valid?(123)).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?(nil)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!('test') }.not_to raise_error
      expect { type.validate!(:test) }.not_to raise_error

      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  shared_examples 'type-checking / type-validation (nilable)' do
    specify 'type-checking' do
      expect(type.valid?('test')).to eq(true)
      expect(type.valid?(:test)).to eq(true)
      expect(type.valid?(nil)).to eq(true)

      expect(type.valid?(123)).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!('test') }.not_to raise_error
      expect { type.validate!(:test) }.not_to raise_error
      expect { type.validate!(nil) }.not_to raise_error

      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  context 'non-nilable type' do
    let(:type) { SmartCore::Types::Value::Text }

    it_behaves_like 'type-casting'
    it_behaves_like 'type-checking / type-validation (non-nilable)'
  end

  context 'runtime-based non-nilable type' do
    let(:type) { SmartCore::Types::Value::Text() }

    it_behaves_like 'type-casting'
    it_behaves_like 'type-checking / type-validation (non-nilable)'
  end

  context 'nilable type' do
    let(:type) { SmartCore::Types::Value::Text.nilable }

    it_behaves_like 'type-casting'
    it_behaves_like 'type-checking / type-validation (nilable)'
  end

  context 'runtime-based nilable type' do
    let(:type) { SmartCore::Types::Value::Text().nilable }

    it_behaves_like 'type-casting'
    it_behaves_like 'type-checking / type-validation (nilable)'
  end

  specify 'has no support for runtime attributes' do
    expect { SmartCore::Types::Value::Text(:test) }.to raise_error(
      SmartCore::Types::RuntimeAttriburtesUnsupportedError
    )

    expect { SmartCore::Types::Value::Text('test') }.to raise_error(
      SmartCore::Types::RuntimeAttriburtesUnsupportedError
    )
  end
end
