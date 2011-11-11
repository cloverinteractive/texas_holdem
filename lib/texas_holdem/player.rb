module TexasHoldem
  module Player
    def is_holdem_player options={}
      return if included_modules.include? IntanceMethods

      cattr_accessor :initial_credit

      self.initial_credit = options[:initial_credit] || 100

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

        attr_protected :credit
        scope :lesser_credit, order( 'credit' )
      end

    end
  end
end

ActiveRecord::Base.send :extend, TexasHoldem::Player
