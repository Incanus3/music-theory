require 'spec_helper'
require 'music-theory/tone'

describe Tone do
  it '#previous_semitone returns the semitone following given tone' do
    expect(Tone.by_name('C#').previous_semitone).to eq Tone.by_name('C')
    expect(Tone.by_name('Eb').previous_semitone).to eq Tone.by_name('D')
    expect(Tone.by_name('A').previous_semitone).to eq Tone.by_name('G#')
  end

  it '#next_semitone returns the semitone following given tone' do
    expect(Tone.by_name('C').next_semitone).to eq Tone.by_name('C#')
    expect(Tone.by_name('Db').next_semitone).to eq Tone.by_name('D')
    expect(Tone.by_name('G#').next_semitone).to eq Tone.by_name('A')
  end

  it '#as_sharp returns the sharp enharmonic variant' do
    expect(Tone.by_name('Db').as_sharp).to eq Tone.by_name('C#')
  end

  it '#as_flat returns the flat enharmonic variant' do
    expect(Tone.by_name('C#').as_flat).to eq Tone.by_name('Db')
  end
end
