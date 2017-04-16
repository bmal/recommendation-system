require_relative '../content_based_filtering'
require_relative 'test_helper'
require 'minitest/autorun'
require 'minitest/ci'
require 'mocha/mini_test'

class ContentBasedFilteringTestSuite < MiniTest::Test
    include TestHelper

    TESTED_USER = "Toby"
    DISSIMILAR_MOVIES = [
        "Kobieta w błękitnej wodzie",
        "Całe szczęście",
        "Ja, ty i on",
        "Nocny słuchacz",
        "Dexter"]

    SIMILAR_MOVIE = "Węże w samolocie"
    VERY_SIMILAR_MOVIE = "Superman: Powrót"

    DISSIMILAR = 0
    SIMILAR = 0.5
    VERY_SIMILAR = 1

    def setup
        @correlation_coefficient_mock = mock
        expect_setting_transformed_prefs
    end

    def expect_setting_transformed_prefs
        @correlation_coefficient_mock.expects(:prefs=).at_least_once
    end

    def expect_no_similar_movies
        MOVIES.each do |movie|
            MOVIES.each do |other_movie|
                @correlation_coefficient_mock.stubs(:calculate_similarity).with(movie, other_movie).returns(DISSIMILAR) unless movie == other_movie
            end
        end

        @sut = ContentBasedFiltering.new(CRITICS, @correlation_coefficient_mock, DISSIMILAR)
    end

    def expect_one_similar_movie_and_one_very_similar
        DISSIMILAR_MOVIES.each do |movie|
            DISSIMILAR_MOVIES.each do |other_movie|
                @correlation_coefficient_mock.stubs(:calculate_similarity).with(movie, other_movie).returns(DISSIMILAR) unless movie == other_movie
            end
        end

        DISSIMILAR_MOVIES.each do |other_movie|
            @correlation_coefficient_mock.stubs(:calculate_similarity).with(SIMILAR_MOVIE, other_movie).returns(SIMILAR)
        end

        DISSIMILAR_MOVIES.each do |other_movie|
            @correlation_coefficient_mock.stubs(:calculate_similarity).with(other_movie, SIMILAR_MOVIE).returns(SIMILAR)
        end

        DISSIMILAR_MOVIES.each do |other_movie|
            @correlation_coefficient_mock.stubs(:calculate_similarity).with(VERY_SIMILAR_MOVIE, other_movie).returns(VERY_SIMILAR)
        end

        DISSIMILAR_MOVIES.each do |other_movie|
            @correlation_coefficient_mock.stubs(:calculate_similarity).with(other_movie, VERY_SIMILAR_MOVIE).returns(VERY_SIMILAR)
        end

        @correlation_coefficient_mock.stubs(:calculate_similarity).with(VERY_SIMILAR_MOVIE, SIMILAR_MOVIE).returns(VERY_SIMILAR)
        @correlation_coefficient_mock.stubs(:calculate_similarity).with(SIMILAR_MOVIE, VERY_SIMILAR_MOVIE).returns(VERY_SIMILAR)

        @sut = ContentBasedFiltering.new(CRITICS, @correlation_coefficient_mock, DISSIMILAR)
    end

    def test_that_full_list_of_recommendations_is_calculated_correctly
        expect_one_similar_movie_and_one_very_similar

        expected_result = {
            "Dexter" => 4.166666666666667,
            "Nocny słuchacz" => 4.166666666666667,
            "Całe szczęście" => 4.166666666666667,
            "Kobieta w błękitnej wodzie" => 4.166666666666667} 

        assert_equal expected_result, @sut.calculate_recommendations(TESTED_USER)
    end

    def test_that_no_recommendation_will_be_returned_when_there_is_no_similar_users
        expect_no_similar_movies

        assert_equal({}, @sut.calculate_recommendations(TESTED_USER))
    end

    def test_that_exception_should_be_thrown_when_there_is_no_such_user_in_dataset
        expect_no_similar_movies

        assert_raises(NoSuchUserException) do
           @sut.calculate_recommendations(NONEXISTING_USER_1)
        end
    end
end
