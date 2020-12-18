# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Value::Proc' do
  shared_examples 'type-casting' do
    specify 'proc => proc' do
      proc_object = proc { |a, b| }
      expect(type.cast(proc_object)).to eq(proc_object)
    end

    specify 'lambda => lambda' do
      lambda_object = -> (a, b) {}
      expect(type.cast(lambda_object)).to eq(lambda_object).and be_a(::Proc)
    end

    specify 'castable => proc' do
      expect(type.cast(:to_s)).to be_a(::Proc)
      expect(type.cast(Class.new { def to_proc; proc {}; end; }.new)).to be_a(::Proc)
    end

    specify 'invalid casting' do
      expect { type.cast(Class.new.new) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast(Object.new) }.to raise_error(SmartCore::Types::TypeCastingError)

      non_castable = Class.new { def to_proc; nil; end; }.new
      expect { type.cast(non_castable) }.to raise_error(SmartCore::Types::TypeCastingError)
    end
  end

  shared_examples 'type-checking / type-validation (non-nilable)' do
    specify 'type-checking' do
      expect(type.valid?(-> {})).to eq(true)
      expect(type.valid?(proc {})).to eq(true)

      expect(type.valid?(nil)).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?([])).to eq(false)
      expect(type.valid?('test')).to eq(false)
      expect(type.valid?(:test)).to eq(false)
      expect(type.valid?(true)).to eq(false)
      expect(type.valid?(false)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(-> {}) }.not_to raise_error
      expect { type.validate!(proc {}) }.not_to raise_error

      expect { type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(true) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(false) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  shared_examples 'type-checking / type-validation (nilable)' do
    specify 'type-checking' do
      expect(type.valid?(-> {})).to eq(true)
      expect(type.valid?(proc {})).to eq(true)
      expect(type.valid?(nil)).to eq(true)

      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?([])).to eq(false)
      expect(type.valid?('test')).to eq(false)
      expect(type.valid?(:test)).to eq(false)
      expect(type.valid?(true)).to eq(false)
      expect(type.valid?(false)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(-> {}) }.not_to raise_error
      expect { type.validate!(proc {}) }.not_to raise_error
      expect { type.validate!(nil) }.not_to raise_error

      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(true) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(false) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  context 'non-nilable type' do
    let(:type) { SmartCore::Types::Value::Proc }

    it_behaves_like 'type-casting'
    it_behaves_like 'type-checking / type-validation (non-nilable)'
  end

  context 'runtime-based non-nilable type' do
    let(:type) { SmartCore::Types::Value::Proc() }

    it_behaves_like 'type-casting'
    it_behaves_like 'type-checking / type-validation (non-nilable)'
  end

  context 'nilable type' do
    let(:type) { SmartCore::Types::Value::Proc.nilable }

    it_behaves_like 'type-casting'
    it_behaves_like 'type-checking / type-validation (nilable)'
  end

  context 'runtime-based nilable type' do
    let(:type) { SmartCore::Types::Value::Proc().nilable }

    it_behaves_like 'type-casting'
    it_behaves_like 'type-checking / type-validation (nilable)'
  end

  specify 'has no support for runtime attributes' do
    expect { SmartCore::Types::Value::Proc((proc {})) }.to raise_error(
      SmartCore::Types::RuntimeAttriburtesUnsupportedError
    )

    expect { SmartCore::Types::Value::Proc((-> {})) }.to raise_error(
      SmartCore::Types::RuntimeAttriburtesUnsupportedError
    )
  end
end
