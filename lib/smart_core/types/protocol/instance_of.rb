# frozen_string_literal: true

# NOTE: BasicObject has no #is_a? instance method. We need to hack this situation :)
is_a = ::Object.new.method(:is_a?).unbind

# @api public
# @since 0.3.0
SmartCore::Types::Protocol.define_type(:InstanceOf) do |type|
  type.runtime_attributes_checker do |runtime_attrs|
    runtime_attrs.all? do |runtime_attr|
      is_a.bind(runtime_attr).call(::Class)
    end
  end

  type.define_checker do |value, expected_types|
    expected_types.any? do |expected_type|
      is_a.bind(value).call(expected_type)
    end
  end
end
