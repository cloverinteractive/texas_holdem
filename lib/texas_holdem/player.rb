module TexasHoldem
  module Player
    def acts_as_holdem_player options={}
      return if included_modules.include? IntanceMethods

      cattr_accessor :initial_credit, :game_class

      self.initial_credit = options[:initial_credit] || 100
      self.game_class     = options[:game_class]

      include InstanceMethods
      extend ClassMethods
    end

    module InstaceMethods
      def bet amount
        raise NotEnoughCreditsError unless self.credits >= amount
        self.update_attributes!( :credits => self.credits - amount )
      end

      def fold
      end

      def take_winnings share
        self.update_attributes!( :credits => self.credits + share )
      end

      def check
        bet 0
      end

      def add_initial_credit
        self.credit = self.initial_credit
      end
    end

    module ClassMethods
      extend ActiveSupport::Concern

      included do
        validates     :credit, :presence => true, :numericality => { :greater_than_or_equal_to => 0 }
        after_create  :add_initial_credit

        has_many :poker_hands # must define this model within gem
        has_many :games, :source =>  self.game_class, :foreign_key => :winner_id

        attr_protected :credit
        scope :lesser_credit, order( 'credit' )
      end

    end
  end
end

ActiveRecord::Base.send :extend, TexasHoldem::Player
