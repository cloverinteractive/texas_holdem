module TexasHoldem
  module Game
    def is_holdem_game options
      return if included_modules.include? InstanceMethods

      cattr_accessor :small_blind_percentage, :player_class

      self.small_blind_percentage = options[:small_blind_percentage] || 0.0125
      self.player_class           = options[:player_class]

      include InstanceMethods
      extend ClassMethods
    end

    module InstanceMethods
      def small_blind
        small_blind_percentage * entrance_fee
      end
    end

    module ClassMethods
      extend ActiveSupport::Concern

      included do
        has_many      :players, :source => self.player_class
        belongs_to    :winner,  :source => self.player_class, :foreign_key => :winner_id

        validates :entrance_fee, :presence => true, :numericality => { :greater_than => 0 }
      end
    end
  end
end

ActiveRecord::Base.send :extend, TexasHoldem::Game
