Dir[ "{lib}/*.rb", "{lib}/**/*.rb"  ].each { |file| require file } # require our lib files

require 'mocha'
require 'turn'
require 'active_support'

class ActiveSupport::TestCase
  def assert_cards(number,players)
    assert players.all? {|player| player.cards.size == number }
  end
end

class String
  include Test::Unit::Assertions
  
  def hand_name(name)
    hand = TexasHoldem::PlayerHand.create(self)
    assert_equal name, hand.name, "\n#{hand.cards} not recognised as a #{name}\n"
  end
  
  def beats(loser)
    winner, loser = TexasHoldem::PlayerHand.create(self), TexasHoldem::PlayerHand.create(loser)
    assert winner > loser, "\n #{winner.name} (#{winner.score}) should beat #{loser.name} (#{loser.score})\n"
  end
end

class TexasHoldem::Hand
  def self.factory(small_blind=1.25)
    players = %w( Amy Bill Carl ).map {|name| TexasHoldem::Player.factory name }
    new players, small_blind
  end
  
  def advance_to_round(number)
    (number - 1).times do
      deal
      round_next
    end
  end
end

class TexasHoldem::Player
  def self.factory(name, cash=100)
    new name, cash
  end
end

module HandTestHelper
  def setup
    @hand = TexasHoldem::Hand.factory
    @amy, @bill, @carl = *@hand.players
  end
end
