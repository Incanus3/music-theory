require 'spec_helper'
require 'music-theory/scale'

describe Mode do
  it 'returns correct semitone positions' do
    # major mode - degree 1 - no shift
    expect(Mode.by_name('major').semitone_positions).to eq [3, 7]
    # minor mode - degree 6
    # - base tone shifts by 5 to the right
    # - semitones shift  by 5 to the left
    # - 3 - 5 % 7 = -2 % 7 = 5
    # - 7 - 5 % 7 =  2 % 7 = 2
    expect(Mode.by_name('minor').semitone_positions).to eq [2, 5]
  end
end

describe Scale do
  def tone_seq_for(scale)
    tones = scale.tones.map(&:name).join(' ')
  end

  it 'consists of 7 tones' do
    scale = Scale.new('C', 'major')
    tones = scale.tones

    expect(tones.all? { |t| t.is_a? Tone }).to be true
    expect(tones.count).to eq 7
  end

  it 'computes correct tones from base tone and mode' do
    expect(tone_seq_for(Scale.new('C', 'major'))).to eq 'C D E F G A B'
    expect(tone_seq_for(Scale.new('G', 'major'))).to eq 'G A B C D E F#'
    expect(tone_seq_for(Scale.new('A', 'minor'))).to eq 'A B C D E F G'
    expect(tone_seq_for(Scale.new('E', 'minor'))).to eq 'E F# G A B C D'
  end

  it 'returns used accidentals' do
    expect(Scale.new('G', 'major').accidentals).to eq [Tone.by_name('F#')]
  end

  # there's 1 major scale with 0 accidentals, 2 with 1-4 accidentals and 3 with all 5 accidentals
  # let's construct the two sequences accidental chains and see how the last scale fits into the
  # picture
  describe 'accidental sequences', :focus do
    it 'generates them properly' do
      scales_by_accidental_count =
        Scale::SEMITONES
        .map { |tone| Scale.new(tone) }
        .group_by { |scale| scale.accidentals.count }

      # pp scales_by_accidental_count.to_a
      #   .sort_by { |(num_of_accidentals, _)| num_of_accidentals }
      #   .map {|(num_of_accidentals, scales)| [num_of_accidentals, scales.map { |scale|
      #     [scale, scale.accidentals] }] }

      # pp scales_with_accidentals

      # flats sequence

      scales      = [scales_by_accidental_count[0][0], scales_by_accidental_count[1][0]]
      accidentals = scales.last.accidentals
      sequence    = scales.map(&:accidentals)

      (2..5).each do |count|
        scale = scales_by_accidental_count[count].find { |scale|
          (scale.accidentals - accidentals).count == 1 }
        accidentals += scale.accidentals - accidentals
        sequence << accidentals
        scales   << scale
      end

      pp Hash[scales.zip(sequence)]

      # sharps sequence

      scales      = [scales_by_accidental_count[0][0], scales_by_accidental_count[1][1]]
      accidentals = scales.last.accidentals
      sequence    = scales.map(&:accidentals)

      (2..5).each do |count|
        scale = scales_by_accidental_count[count].find { |scale|
          (scale.accidentals - accidentals).count == 1 }
        accidentals += scale.accidentals - accidentals
        sequence << accidentals
        scales   << scale
      end

      pp Hash[scales.zip(sequence)]
    end
  end
end
