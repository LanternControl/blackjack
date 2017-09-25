require_relative "card"

class Deck
  def initialize
    @cards = []
    Card::SUITS.each do |suit|
      Card::RANKS.each do |rank|
        @cards.push(Card.new(rank,suit))
      end
    end
  end

  def cards_remaining
    @cards.length
  end

  def hit
    @cards.shift
  end

  def shuffle
    @cards.shuffle
  end
