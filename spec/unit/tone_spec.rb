require 'spec_helper'
require 'music-theory/tone'

describe Tone do
  it '#as_sharp returns the sharp enharmonic variant' do
    expect(Tone.by_name('Db').as_sharp).to eq Tone.by_name('C#')
  end

  it '#as_flat returns the flat enharmonic variant' do
    expect(Tone.by_name('C#').as_flat).to eq Tone.by_name('Db')
  end
end
