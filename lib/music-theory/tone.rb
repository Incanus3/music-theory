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

  # 1-based position
  def self.variant(position, accidental)
    group = SEMITONES[position - 1]

    case accidental
    when :none, :sharp then group[0]
    when :flat  then group[1]
    when :force_sharp
      hidden = group[2]
      hidden && hidden.sharp? ? hidden : group[0]
    when :force_flat
      hidden = group[2]
      hidden && hidden.flat?  ? hidden : group[1]
    end
  end

  # [<canonical # form>, <canonical b form>, <hidden #/b form if present>]
  SEMITONES = CyclicArray.new([['A', 'A'],       ['A#', 'Bb'], ['B', 'B', 'Cb'], ['C', 'C', 'B#'],
                               ['C#', 'Db'],     ['D', 'D'],   ['D#', 'Eb'],     ['E', 'E', 'Fb'],
                               ['F', 'F', 'E#'], ['F#', 'Gb'], ['G', 'G'],       ['G#', 'Ab']]
    .map { |group| group.map { |name| by_name(name) } })

  def name
    "#{base_name}#{ACCIDENTALS[accidental]}"
  end

  def plain?
    accidental == :none
  end

  def sharp?
    accidental == :sharp
  end

  def flat?
    accidental == :flat
  end

  def forced?
    !plain? && variant(accid: accidental).plain?
  end

  def previous_semitone
    variant(pos: position - 1)
  end

  def next_semitone
    variant(pos: position + 1)
  end

  def as_sharp
    variant(accid: :sharp)
  end

  def as_flat
    variant(accid: :flat)
  end

  def ===(other)
    self.variant(accid: :sharp) == other.variant(accid: :sharp)
  end

  def inspect
    "<#{self.class.name} #{name}>"
  end

  def to_s
    name
  end

  # 1-based
  def position
    @_position = SEMITONES.index { |tones| tones.include?(self) } + 1
  end

  def variant(pos: position, accid: accidental)
    self.class.variant(pos, accid)
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
