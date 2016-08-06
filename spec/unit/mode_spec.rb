require 'spec_helper'
require 'music-theory/mode'

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
