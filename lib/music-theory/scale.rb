require_relative 'utils'
require_relative 'types'
require_relative 'tone'
require_relative 'mode'

# terminology (may be incorrect and change with the evolution of my understanding)
# tone = pitch - the height of the sound (don't consider overtones now)
# note = tone + length - e.g. half C# note

class Scale
  def self.sequence(size, start, step, accidental = :sharp)
    start = start.position if start.is_a?(Tone)
    Array.new(size) { |i| Tone.variant(start + step * i, accidental) }
  end

  SHARPS_SEQUENCE = sequence(7, Tone.by_name('F#'),  7, :force_sharp)
  FLATS_SEQUENCE  = sequence(7, Tone.by_name('Bb'), -7, :force_flat)

  SHARP_SCALE_BASES = sequence(8, Tone.by_name('C'),  7, :sharp)
  FLAT_SCALE_BASES  = sequence(8, Tone.by_name('C'), -7, :force_flat)

  attr_reader :base_tone, :mode

  def initialize(base_tone, mode = :major)
    @base_tone = Tone(base_tone)
    @mode      = Mode(mode)
  end

  def tones
    @_tones = _tones
  end

  def sharp?
    !flat?
  end

  def flat?
    base_tone.flat? || base_tone == Tone.by_name('F')
  end

  # 1-based
  def nth_tone(n)
    position = base_tone.position + semitone_distance(n)
    variant  = flat? ? :flat : :sharp

    Tone.variant(position, variant)
  end

  # this now breaks for non-major scales
  def accidentals
    @_accidentals = _accidentals
  end

  def inspect
    "<#{self.class.name} #{self}>"
  end

  def to_s
    "#{base_tone} #{mode.human_name}"
  end

  private

  # 1-based
  def semitone_distance(tone_num)
    (tone_num - 1) * 2 - mode.semitone_positions.count { |pos| pos < tone_num }
  end

  def _tones
    tones  = Array.new(7) { |i| nth_tone(i + 1) }
    forced = accidentals.select(&:forced?)

    tones.map { |tone| forced.find { |accid| tone === accid } || tone }
  end

  def _accidentals
    if sharp?
      SHARPS_SEQUENCE.take(SHARP_SCALE_BASES.index(base_tone))
    else
      FLATS_SEQUENCE.take(FLAT_SCALE_BASES.index(base_tone))
    end
  end
end
