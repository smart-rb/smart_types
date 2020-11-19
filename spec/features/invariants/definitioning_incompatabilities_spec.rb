# frozen_string_literal: true

RSpec.describe 'INVARIANTS: Type invariant definitioning incompatabilities' do
  specify 'definition incompatabilities' do
    aggregate_failures 'definition_incompatabilities' do
      expect do # missing invariant name, missing block argument
        SmartCore::Types::Value.define_type(:DefIncFirstSpec) do |type|
          type.define_checker { true }
          type.invariant
        end
      end.to raise_error(::ArgumentError)

      expect do # missing invariant chain name, missing block argument
        SmartCore::Types::Value.define_type(:DefIncFirstSpec) do |type|
          type.define_checker { true }
          type.invariant_chain
        end
      end.to raise_error(::ArgumentError)

      expect do # missing block argument
        SmartCore::Types::Value.define_type(:DefIncFirstSpec) do |type|
          type.define_checker { true }
          type.invariant(:some_check)
        end
      end.to raise_error(::SmartCore::Types::ArgumentError)

      expect do # empty invariant name
        SmartCore::Types::Value.define_type(:DefIncFirstSpec) do |type|
          type.define_checker { true }
          type.invariant('') {}
        end
      end.to raise_error(::SmartCore::Types::ArgumentError)

      expect do # empty invariant name
        SmartCore::Types::Value.define_type(:DefIncFirstSpec) do |type|
          type.define_checker { true }
          type.invariant(:"") {}
        end
      end.to raise_error(::SmartCore::Types::ArgumentError)

      expect do # incompatible invariant name
        SmartCore::Types::Value.define_type(:DefIncFirstSpec) do |type|
          type.define_checker { true }
          type.invariant(Object.new) {}
        end
      end.to raise_error(::SmartCore::Types::ArgumentError)

      expect do # incompatible invariant name
        SmartCore::Types::Value.define_type(:DefIncFirstSpec) do |type|
          type.define_checker { true }
          type.invariant(nil) {}
        end
      end.to raise_error(::SmartCore::Types::ArgumentError)

      expect do # missing block argument
        SmartCore::Types::Value.define_type(:DefIncFirstSpec) do |type|
          type.define_checker { true }
          type.invariant_chain(:some_check)
        end
      end.to raise_error(::SmartCore::Types::ArgumentError)

      expect do # empty invariant chain name
        SmartCore::Types::Value.define_type(:DefIncFirstSpec) do |type|
          type.define_checker { true }
          type.invariant_chain('') {}
        end
      end.to raise_error(::SmartCore::Types::ArgumentError)

      expect do # empty invariant chain name
        SmartCore::Types::Value.define_type(:DefIncFirstSpec) do |type|
          type.define_checker { true }
          type.invariant_chain(:"") {}
        end
      end.to raise_error(::SmartCore::Types::ArgumentError)

      expect do # incompatible invariant name
        SmartCore::Types::Value.define_type(:DefIncFirstSpec) do |type|
          type.define_checker { true }
          type.invariant_chain(Object.new) {}
        end
      end.to raise_error(::SmartCore::Types::ArgumentError)

      expect do # incompatible invariant name
        SmartCore::Types::Value.define_type(:DefIncFirstSpec) do |type|
          type.define_checker { true }
          type.invariant_chain(nil) {}
        end
      end.to raise_error(::SmartCore::Types::ArgumentError)

      expect do # invariant without name (inside nested chain)
        SmartCore::Types::Value.define_type(:DefIncFirstSpec) do |type|
          type.define_checker { true }
          type.invariant_chain('test') do
            invariant
          end
        end
      end.to raise_error(::ArgumentError)

      expect do # missing invariant block (inside nested chain)
        SmartCore::Types::Value.define_type(:DefIncFirstSpec) do |type|
          type.define_checker { true }
          type.invariant_chain('test') do
            invariant(:test_invariant)
          end
        end
      end.to raise_error(::ArgumentError)

      expect do # empty invariant name (inside nested chain)
        SmartCore::Types::Value.define_type(:DefIncFirstSpec) do |type|
          type.define_checker { true }
          type.invariant_chain('test') do
            invariant(:"") {}
          end
        end
      end.to raise_error(::SmartCore::Types::ArgumentError)

      expect do # empty invariant name (inside nested chain)
        SmartCore::Types::Value.define_type(:DefIncFirstSpec) do |type|
          type.define_checker { true }
          type.invariant_chain('test') do
            invariant('') {}
          end
        end
      end.to raise_error(::SmartCore::Types::ArgumentError)

      expect do # incompatible invariant name (inside nested chain)
        SmartCore::Types::Value.define_type(:DefIncFirstSpec) do |type|
          type.define_checker { true }
          type.invariant_chain('test') do
            invariant(nil) {}
          end
        end
      end.to raise_error(::SmartCore::Types::ArgumentError)

      expect do # incompatible invariant name (inside nested chain)
        SmartCore::Types::Value.define_type(:DefIncFirstSpec) do |type|
          type.define_checker { true }
          type.invariant_chain('test') do
            invariant(Object.new) {}
          end
        end
      end.to raise_error(::SmartCore::Types::ArgumentError)
    end
  end
end
