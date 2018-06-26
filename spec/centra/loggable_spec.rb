# frozen_string_literal: true

require "spec_helper"

RSpec.describe Centra::Loggable do
  context "when included" do
    it "defines #log method" do
      klass = Class.new { include Centra::Loggable }
      expect(klass.new.log).to be_a(Logger)
    end

    it "defines ::log method" do
      klass = Class.new { include Centra::Loggable }
      expect(klass.log).to be_a(Logger)
    end
  end
end
