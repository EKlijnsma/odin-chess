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
end
