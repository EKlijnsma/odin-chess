# frozen_string_literal: true

require_relative '../lib/pawn'

describe Pawn do
  context 'when white' do
    subject(:pawn) { described_class.new(:white) }

    it 'has forward and capture offsets' do
      expect(pawn.possible_moves).to include([-1, 0], [-2, 0], [-1, 1], [-1, -1])
    end
  end

  context 'when black' do
    subject(:pawn) { described_class.new(:black) }

    it 'has forward and capture offsets' do
      expect(pawn.possible_moves).to include([1, 0], [2, 0], [1, 1], [1, -1])
    end
  end
end
