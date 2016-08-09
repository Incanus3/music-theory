require 'spec_helper'
require 'music-theory/scale'

describe Scale do
  def tone_seq(tones)
    tones.map(&:name).join(' ')
  end

  def tone_seq_for(scale)
    tone_seq(scale.tones)
  end

  it '#tones computes correct tones from base tone and mode' do
    expect(tone_seq_for(Scale.new('C',  'major'))).to eq 'C D E F G A B'
    expect(tone_seq_for(Scale.new('G',  'major'))).to eq 'G A B C D E F#'
    expect(tone_seq_for(Scale.new('C#', 'major'))).to eq 'C# D# E# F# G# A# B#'
    expect(tone_seq_for(Scale.new('Cb', 'major'))).to eq 'Cb Db Eb Fb Gb Ab Bb'
    expect(tone_seq_for(Scale.new('A',  'minor'))).to eq 'A B C D E F G'
    expect(tone_seq_for(Scale.new('E',  'minor'))).to eq 'E F# G A B C D'
  end

  it '#accidentals returns used accidentals' do
    expect(tone_seq(Scale.new('C',  'major').accidentals)).to eq ''
    expect(tone_seq(Scale.new('G',  'major').accidentals)).to eq 'F#'
    expect(tone_seq(Scale.new('C#', 'major').accidentals)).to eq 'F# C# G# D# A# E# B#'
    expect(tone_seq(Scale.new('Cb', 'major').accidentals)).to eq 'Bb Eb Ab Db Gb Cb Fb'
    # expect(tone_seq(Scale.new('A',  'minor').accidentals)).to eq ''
    # expect(tone_seq(Scale.new('E',  'minor').accidentals)).to eq 'F#'
  end
end
