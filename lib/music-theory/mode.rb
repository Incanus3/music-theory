require 'dry-initializer'
require 'dry-equalizer'
require_relative 'types'

class Mode
  extend  Dry::Initializer::Mixin
  include Dry::Equalizer(:name)

  MODES   = %i[ionian dorian phrygian lydian mixolydian aeolian locrian]
  ALIASES = { major: :ionian, minor: :aeolian}

  param :name, type: Types::Symbol.enum(*MODES)

  def self.by_name(name)
    sym_name = name.to_sym
    new(ALIASES[sym_name] || sym_name)
  end

  def self.by_degree(degree)
    new(MODES[(degree - 1) % MODES.count])
  end

  def human_name
    ALIASES.invert[name] || name
  end

  # 1-based
  def degree
    MODES.index(name) + 1
  end

  # 1-based
  def semitone_positions
    [3, 7].map { |pos| ((pos - degree) % 7) + 1 }.sort
  end
end

def Mode(desc)
  case desc
  when Mode
    desc
  when Symbol, String
    Mode.by_name(desc)
  else
    raise ArgumentError, "#{desc} is not a proper mode descriptor"
  end
end
