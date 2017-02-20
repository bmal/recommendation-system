require_relative '../correlation_coefficient'
require_relative 'test_helper'
require 'minitest/autorun'
require 'minitest/ci'

class CorrelationCoefficientTestSuit < MiniTest::Test
    include TestHelper
    def setup
        @sut = CorrelationCoefficient.new(CRITICS)
    end

    def test_that_when_similarity_is_calculated_exception_should_be_thrown
        assert_raises AbstractMethodCalled do
            @sut.calculate_similarity(EXISTING_USER_1, EXISTING_USER_2)
        end
    end
end
