require_relative "deck"

  class Hand
    attr_accessor :player_cards, :dealer_cards

  def initialize
    @player_hand = []
    @dealer_hand = []
    @deck = Deck.new.shuffle
    @card = []
  end

  def deal
    # maybe add in some input
    2.times{deal_card(@player_hand)}
    2.times{deal_card(@dealer_hand)}
  end

  def deal_card(hand)
    @card = @deck.shift
    @card_rank = @card.rank
    hand.push(@card)
  end

  def ace
    if @card_values.inject(&:+) < 11
      @card_values.inject(&:+) + 11
    else
      @card_values.inject(&:+) + 1
    end
  end

  def get_total(cards)
      @card_values = cards.map { |card| card.rank  }
      @card_values.map! { |value| (value === :J || value === :Q || value === :K ? 10 : value) }
      if @card_values.include?(:A)
        @card_values.delete_at(@card_values.find_index(:A))
        if @card_values.include?(:A)
          while @card_values.include?(:A)
            @card_values.delete_at(@card_values.find_index(:A))
            @card_values.push(1)
          end
          ace
        else
          ace
        end
      else
        @card_values.inject(&:+)
      end
    end

  end
