# frozen_string_literal: true

require_relative '../lib/player'

describe Player do
  let(:color) { 'black' }
  let(:name) { 'John Doe' }
  subject(:player) { described_class.new(name, color) }

  describe '#initialize' do
    context 'when initialized with name and color' do
      it 'initializes with the given player name' do
        expect(player.name).to eq(name)
      end

      it 'initializes with the given color' do
        expect(player.color).to eq(color)
      end
    end
  end

  describe '#chess_square?' do
    valid_inputs = %w[a1 e5 h8]
    invalid_inputs = %w[a0 j3 ab 12 cancel]

    valid_inputs.each do |input|
      it "returns true for #{input}" do
        expect(player.chess_square?(input)).to be(true)
      end
    end

    invalid_inputs.each do |input|
      it "returns false for #{input}" do
        expect(player.chess_square?(input)).to be(false)
      end
    end
  end
end
