require 'dry-types'

module Types
  include Dry::Types.module

  ToneName = Strict::String.constrained(format: /[A-G][#b]?/)
end
