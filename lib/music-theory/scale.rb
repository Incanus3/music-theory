require_relative 'utils'
require_relative 'types'
require_relative 'tone'
require_relative 'mode'

# terminology (may be incorrect and change with the evolution of my understanding)
# tone = pitch - the height of the sound (don't consider overtones now)
# note = tone + length - e.g. half C# note

class Scale
  SEMITONES = CyclicArray.new(%w[A A# B C C# D D# E F F# G G#]
    .map { |name| Tone.by_name(name) })

  attr_reader :base_tone, :mode, :flat

  def initialize(base_tone, mode = :major, flat: false)
    @base_tone = Tone(base_tone)
    @mode      = Mode(mode)
    @flat      = flat
  end

  def tones
    @_tones = _tones
  end

  # 1-based
  def nth_tone(n)
    base_index = SEMITONES.index(base_tone)
    distance   = semitone_distance(n)

    SEMITONES[(base_index + distance)]
  end

  def accidentals
    tones.select { |t| t.accidental != :none }
  end

  def as_flat
    self.class.new(base_tone, mode, flat: true)
  end

  def inspect
    tone = flat ? base_tone.as_flat : base_tone
    "<#{self.class.name} #{tone} #{mode.human_name}>"
  end

  def self.previous_semitone(tone)
    SEMITONES[(SEMITONES.index(tone.as_sharp) - 1)]
  end

  def self.next_semitone(tone)
    SEMITONES[(SEMITONES.index(tone.as_sharp) + 1)]
  end

  private

  # 1-based
  def semitone_distance(tone_num)
    (tone_num - 1) * 2 - mode.semitone_positions.count { |pos| pos < tone_num }
  end

  def _tones
    tones = Array.new(7) { |i| nth_tone(i + 1) }
    flat ? tones.map(&:as_flat) : tones
  end
end
