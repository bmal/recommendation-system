require_relative '../correlation_coefficient'
require_relative 'test_helper'
require 'minitest/autorun'
require 'minitest/ci'

class CorrelationCoefficientTestSuite < MiniTest::Test
    include TestHelper
    def setup
        @sut = CorrelationCoefficient.new(CRITICS)
    end

    def test_that_when_none_of_the_users_is_in_database_then_similarity_will_be_0
        assert_equal 0, @sut.calculate_similarity(NONEXISTING_USER_1, NONEXISTING_USER_2)
        assert_equal 0, @sut.calculate_similarity(EXISTING_USER_1, NONEXISTING_USER_1)
        assert_equal 0, @sut.calculate_similarity(NONEXISTING_USER_1, EXISTING_USER_1)
    end

    def test_that_when_users_have_no_mutualy_rated_movies_then_similarity_will_be_0
        assert_equal 0, @sut.calculate_similarity(EXISTING_EMPTY_USER, EXISTING_USER_1)
        assert_equal 0, @sut.calculate_similarity(EXISTING_USER_1, EXISTING_EMPTY_USER)
    end

    def test_that_when_similarity_is_calculated_exception_should_be_thrown
        assert_raises AbstractMethodCalled do
            @sut.calculate_similarity(EXISTING_USER_1, EXISTING_USER_2)
        end
    end
end
