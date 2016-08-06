require 'dry-initializer'
require 'dry-equalizer'
require_relative 'utils'
require_relative 'types'

class Tone
  extend  Dry::Initializer::Mixin
  include Dry::Equalizer(:base_name, :accidental)

  NAMES       = CyclicArray.new(%w[A B C D E F G])
  ACCIDENTALS = { none: nil, sharp: '#', flat: 'b' }

  param :base_name,  type: Types::String.enum(*NAMES)
  param :accidental, type: Types::Symbol.enum(*ACCIDENTALS.keys)

  def self.by_name(name)
    Types::ToneName[name]
    new(name[0], ACCIDENTALS.invert[name[1]])
  rescue Dry::Types::ConstraintError
    raise "#{name} is not a proper tone name"
  end

  def name
    "#{base_name}#{ACCIDENTALS[accidental]}"
  end

  def sharp?
    accidental == :sharp
  end

  def flat?
    accidental == :flat
  end

  def as_sharp
    if flat?
      self.class.new(NAMES[NAMES.index(base_name) - 1], :sharp)
    else
      self
    end
  end

  def as_flat
    if sharp?
      self.class.new(NAMES[NAMES.index(base_name) + 1], :flat)
    else
      self
    end
  end

  def inspect
    "<#{self.class.name} #{name}>"
  end

  def to_s
    name
  end
end

def Tone(desc)
  case desc
  when Tone
    desc
  when String
    Tone.by_name(desc)
  else
    raise ArgumentError, "#{desc} is not a proper tone descriptor"
  end
end
