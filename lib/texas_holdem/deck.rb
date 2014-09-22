module TexasHoldem
  module Deck
    def acts_as_holdem_deck options
      return if included_modules.include? InstanceMethods

      cattr_accessor :faces, :suits

      self.faces = "AKQJT98765432"
      self.suits = "cdhs"

      include InstanceMethods
      extend ClassMethods
    end

    module InstanceMethods
      # TODO: change @cards to the cards setter provided by ActiveRecord and convert to hash for proper serialization
      def build
        @cards = []

        self.faces.each_byte do |face|
          self.suits.each_byte { |suit| @cards << ( face.chr + suit.chr ) }
        end
      end

      def shuffle #not convinced by this but will keep it as is and test against the Array#shuffle method
        3.times do
          shuf = []
          @cards.each do |card|
            loc = rand( shuf.size + 1 )
            shuf.insert( loc, card )
          end

          @cards = shuf.reverse
        end
      end
    end

    module ClassMethods
      extend ActiveSupport::Concenr

      setup do
        validates :cards, :presence => true
        serialize :cards
      end
    end
  end
end

ActiveRecord::Base.send :extend, TexasHoldem::Deck
