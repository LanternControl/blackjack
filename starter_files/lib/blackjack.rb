require_relative "card"
require_relative "hand"
require_relative "deck"

class Game
  def initialize
    @hand = Hand.new
    @pot = 100
    @total = 0
  end

  def run
      start_game
  end

  def run_game
    @hand = Hand.new
    @hand.deal
    make_bet
    report_values(@hand.player_hand)
    hit_or_stand
  end

  def start_game
    puts "This is a simple game of BlackJack, try and get as close to 21 as possible without going over"
    run_game
  end

  def make_bet
    puts "You have $#{@pot} and bet $10."
  end

  def hit_or_stand
      puts "Do you want to (h)it or (s)tand?"
      while true
        print "Please enter (h)it or (s)tand: "
        answer = gets.chomp.downcase
        if answer[0] == "h"
          player_hits
          return false
        elsif answer[0] == "s"
          player_stands
          return false
        end
        puts "Please enter (h) or (s)."
      end
    end

  def player_hits
    @hand.deal_card(@hand.player_hand)
    last_card = @hand.player_hand.last.rank
    puts "The dealer deals you a #{last_card}."
    report_values(@hand.player_hand)
    win_or_lose
  end

  def player_stands
    report_values(@hand.dealer_hand)
    dealer_total = @hand.hand_score(@hand.dealer_hand)
    player_total = @hand.hand_score(@hand.player_hand)
    while dealer_total < 17
      @hand.deal_card(@hand.dealer_hand)
      last_card = @hand.dealer_hand.last.rank
      puts "The dealer draws a #{last_card}."
      dealer_total = @hand.hand_score(@hand.dealer_hand)
      puts "Their total is now #{dealer_total}."
    end
    if dealer_total > 21
      puts "Dealer busts!"
    end
    if player_total >= dealer_total || dealer_total > 21
      @pot = @pot + 10
      puts "You win!"
      puts "You have $#{@pot} left."
      play_again
    else
      @pot = @pot - 10
      puts "You lose."
      puts "You have $#{@pot} left."
      play_again
    end
  end

    def report_values(hand)
    @total = @hand.hand_score(hand)
    last_card = hand.last
    other_cards = hand.reverse.drop(1).reverse.map { |card| card.rank  }.join(", a ")
    if hand === @hand.player_hand
      puts "You have a #{other_cards} and a #{last_card.rank} in your hand. Your score is #{@total}."
      puts "The dealer has a #{@hand.dealer_hand[0].rank} and one face-down card."
      if @total === 21
        win_or_lose
      end
    else
      puts "The dealer has a #{other_cards} and a #{last_card.rank} in their hand. Their score is #{@total}."
    end
  end

  def final_hand
    hidden_card = @hand.dealer_hand.last.rank
    puts "You now have $#{@pot}."
    play_again
  end

  def win_or_lose
    if (@total === 21)
      @pot = @pot + 10
      puts "You win!"
      final_hand
    elsif @total > 21
      @pot = @pot - 10
      puts "You lose!"
      final_hand
    elsif @total < 21
      hit_or_stand
    end
  end

  def play_again
    puts "Do you want to play again?"
    print "Please enter (y)es or (n)o: "
    answer = gets.chomp.downcase
    if answer[0] == "y"
      run_game
    elsif answer[0] == "n"
      quit_game
    else
      puts "Please enter (h) or (s)."
      play_again
    end
  end

  def quit_game
    pot_left = @pot - 100
    puts "See you soon! Your ending balance is $#{pot_left}."
    exit
  end

end

Game.new.run
