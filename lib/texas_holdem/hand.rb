module TexasHoldem
  module Hand
    def acts_as_holdem_hand options
      return if included_modules.include? InstanceMethods

      cattr_accessor :small_blind_percentage, :player_class, :game_class

      self.small_blind_percentage = options[:small_blind_percentage] || 0.0125
      self.player_class           = options[:player_class]
      self.game_class             = options[:game_class]

      include InstanceMethods
      extend ClassMethods
    end

    module InstanceMethods
      def small_blind
        small_blind_percentage * entrance_fee
      end

      def minimum_bet
        small_blind * 2
      end
    end

    module ClassMethods
      extend ActiveSupport::Concern

      included do
        belongs_to  :game,    :source => self.game_class
        belongs_to  :dealer,  :source => self.player_class, :foreign_key => :dealer_id

        has_one     :poker_hand # must define this model within gem
        has_many    :players, :through => :poker_hand

        symbolize :round, :in => [ :pocket, :flop, :turn, :river, :showdown ], :methods => true, :scopes => true

        validates :entrance_fee, :presence => true, :numericality => { :greater_than => 0 }
      end
    end
  end
end

ActiveRecord::Base.send :extend, TexasHoldem::Hand
