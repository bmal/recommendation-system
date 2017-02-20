require_relative '../correlation_coefficient'
require_relative 'test_helper'
require 'minitest/autorun'
require 'minitest/ci'

class CorrelationCoefficientTestSuit < MiniTest::Test
    include TestHelper
    def setup
        @sut = CorrelationCoefficient.new(CRITICS)
    end
end
