require_relative '../euclidean_distance'
require_relative 'test_helper'
require 'minitest/autorun'
require 'minitest/ci'

class EuclideanDistanceTestSuite < MiniTest::Test
    include TestHelper
    def setup
        @sut = EuclideanDistance.new(CRITICS)
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

    def test_that_similarity_between_users_that_identically_rated_same_movies_will_be_1
        assert_equal 1, @sut.calculate_similarity(EXISTING_USER_1, EXISTING_USER_1)
        assert_equal 1, @sut.calculate_similarity(EXISTING_USER_1, EXISTING_USER_1_WITH_MORE_RATED_MOVIES)
        assert_equal 1, @sut.calculate_similarity(EXISTING_USER_1_WITH_MORE_RATED_MOVIES, EXISTING_USER_1)
    end

    def test_that_similarity_gives_correct_distance_between_two_random_users
        assert_in_delta 0.29429, @sut.calculate_similarity(EXISTING_USER_1, EXISTING_USER_2), 0.00001
        assert_in_delta 0.29429, @sut.calculate_similarity(EXISTING_USER_2, EXISTING_USER_1), 0.00001
    end
end
