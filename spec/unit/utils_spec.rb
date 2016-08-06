require 'spec_helper'
require 'music-theory/utils'

describe CyclicArray do
  it 'indexing works' do
    array = CyclicArray.new([0, 1, 2])

    expect(array[-1]).to eq 2
    expect(array[1]).to eq 1
    expect(array[20]).to eq 2
  end

  it 'equality and mapping works' do
    array = CyclicArray.new([0, 1, 2])
    expect(array.map { |x| x }).to eq array
  end
end
