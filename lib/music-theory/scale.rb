require 'dry-initializer'
require 'dry-equalizer'
require 'dry-types'

# terminology (may be incorrect and change with the evolution of my understanding)
# tone = pitch - the height of the sound (don't consider overtones now)
# note = tone + length - e.g. half C# note

module Types
  include Dry::Types.module

  ToneName = Strict::String.constrained(format: /[A-G][#b]?/)
end

class Tone
  extend  Dry::Initializer::Mixin
  include Dry::Equalizer(:base_name, :accidental)

  NAMES       = %w[A B C D E F G]
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

class Scale
  SEMITONES = %w[A A# B C C# D D# E F F# G G#].map { |name| Tone.by_name(name) }

  attr_reader :base_tone, :mode

  def initialize(base_tone, mode = :major)
    @base_tone = Tone(base_tone)
    @mode      = Mode(mode)
  end

  def tones
    @_tones = Array.new(7) { |i| nth_tone(i + 1) }
  end

  # 1-based
  def nth_tone(n)
    base_index = SEMITONES.index(base_tone)
    distance   = semitone_distance(n)

    SEMITONES[(base_index + distance) % SEMITONES.count]
  end

  def accidentals
    tones.select { |t| t.accidental != :none }
  end

  def inspect
    "<#{self.class.name} #{base_tone.name} #{mode.human_name}>"
  end

  private

  # 1-based
  def semitone_distance(tone_num)
    (tone_num - 1) * 2 - mode.semitone_positions.count { |pos| pos < tone_num }
  end
end
