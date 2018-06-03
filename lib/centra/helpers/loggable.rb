# frozen_string_literal: true

module Centra
  module Loggable
    def self.included(reciever)
      reciever.class_eval do
        def log
          Centra.configuration.logger
        end

        def self.log
          Centra.configuration.logger
        end
      end
    end
  end
end
