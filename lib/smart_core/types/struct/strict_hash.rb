# frozen_string_literal: true

# @api public
# @since 0.3.0
SmartCore::Types::Struct.define_type(:StrictHash) do |type|
  # TODO: recursively check all nested hashes too
  type.define_checker do |hash, schema|
    hash.is_a?(::Hash) &&
      hash.keys == schema.keys &&
      hash.all? { |key, value| schema[key].valid?(value) }
  end
end
