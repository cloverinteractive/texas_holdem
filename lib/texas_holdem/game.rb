module TexasHoldem
  module Game
    def acts_as_holdem_game options
      return if included_modules.include? InstanceMethods

      cattr_accessor :player_class

      self.player_class = options[:player_class]

      include InstanceMethods
      extend ClassMethods
    end

    module InstanceMethods
    end

    module ClassMethods
      extend ActiveSupport::Concern

      included do
        has_many      :hands,   :source   => self.hand_class
        has_many      :players, :through  => :hands
        belongs_to    :winner,  :source   => self.player_class, :foreign_key => :winner_id
      end
    end
  end
end

ActiveRecord::Base.send :extend, TexasHoldem::Game
