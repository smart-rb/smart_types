# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Value::Hash' do
  shared_examples 'type casting' do
    specify 'type-casting' do
      # TODO: be_a

      expect(type.cast(nil)).to eq({})
      expect(type.cast({})).to eq({})
      expect(type.cast([])).to eq({})
      expect(type.cast([[:a, 1], ['b', 2], ['c', :test]])).to eq({ a: 1, 'b' => 2, 'c' => :test })
      expect(type.cast({ 'fiz' => :baz, kek: 'pek' })).to eq({ 'fiz' => :baz, kek: 'pek' })

      expect { type.cast(1) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast(Object.new) }.to raise_error(SmartCore::Types::TypeCastingError)

      as_hash_1 = Class.new { def to_h; { a: 1, 'b' => :baz }; end; }.new
      as_hash_2 = Class.new { def to_hash; { c: 3, 'd' => :fiz }; end; }.new
      non_hashable_1 = Class.new { def to_h; 1; end; }.new
      non_hashable_2 = Class.new { def to_hash; :test; end; }.new

      expect(type.cast(as_hash_1)).to eq({ a: 1, 'b' => :baz })
      expect(type.cast(as_hash_2)).to eq({ c: 3, 'd' => :fiz })

      expect { type.cast(non_hashable_1) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast(non_hashable_2) }.to raise_error(SmartCore::Types::TypeCastingError)
    end
  end

  context 'non-nilable type' do
    let(:type) { SmartCore::Types::Value::Hash }

    include_examples 'type casting'

    specify 'type-checking' do
      expect(type.valid?({})).to eq(true)
      expect(type.valid?({ a: 1, 'b' => 2 })).to eq(true)

      expect(type.valid?(nil)).to eq(false)
      expect(type.valid?(123)).to eq(false)
      expect(type.valid?([])).to eq(false)
      expect(type.valid?([[:a, 1], ['b', Object.new]])).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!({}) }.not_to raise_error
      expect { type.validate!({ a: 1, 'b' => 2 }) }.not_to raise_error

      expect { type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([[:a, 1], ['b', :test]]) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  context 'nilable type' do
    let(:type) { SmartCore::Types::Value::Hash.nilable }

    include_examples 'type casting'

    specify 'type-checking' do
      expect(type.valid?({})).to eq(true)
      expect(type.valid?({ a: 1, 'b' => 2 })).to eq(true)
      expect(type.valid?(nil)).to eq(true)

      expect(type.valid?(123)).to eq(false)
      expect(type.valid?([])).to eq(false)
      expect(type.valid?([[:a, 1], ['b', Object.new]])).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!({}) }.not_to raise_error
      expect { type.validate!({ a: 1, 'b' => 2 }) }.not_to raise_error
      expect { type.validate!(nil) }.not_to raise_error

      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([[:a, 1], ['b', :test]]) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
    end
  end
end
