require_relative '../correlation_coefficient'
require_relative 'critics'
require 'minitest/autorun'
require 'minitest/ci'

if ENV["CIRCLECI"]
  Minitest::Ci.report_dir = "#{ENV["CIRCLE_TEST_REPORTS"]}/reports"
end

class CorrelationCoefficientTestSuit < MiniTest::Unit::TestCase
    NONEXISTING_USER_1 = "Krzesło"
    NONEXISTING_USER_2 = "Lampa"
    EXISTING_USER_1 = "Lisa Rose"
    EXISTING_USER_1_WITH_MORE_RATED_MOVIES = "Lana Rose"
    EXISTING_USER_1_WITH_SCORES_SHIFTED_BY_CONSTANT = "Robert Rose"
    EXISTING_USER_2 = "Gene Seymour"
    EXISTING_USER_2_WITH_MORE_RATED_MOVIES = "Bob Seymour"
    EXISTING_USER_3 = "Michael Phillips"
    EXISTING_EMPTY_USER = "Donald Trump"

    def setup
        @sut = CorrelationCoefficient.new($critics)
    end

    def test_that_when_any_of_the_users_is_not_in_database_then_euclidean_distance_will_be_0
        assert_equal 0, @sut.euclidean_distance(NONEXISTING_USER_1, NONEXISTING_USER_2)
        assert_equal 0, @sut.euclidean_distance(EXISTING_USER_1, NONEXISTING_USER_1)
        assert_equal 0, @sut.euclidean_distance(NONEXISTING_USER_1, EXISTING_USER_1)
    end

    def test_that_when_users_have_no_mutualy_rated_movies_then_euclidean_distance_will_be_0
        assert_equal 0, @sut.euclidean_distance(EXISTING_EMPTY_USER, EXISTING_USER_1)
        assert_equal 0, @sut.euclidean_distance(EXISTING_USER_1, EXISTING_EMPTY_USER)
    end

    def test_that_euclidean_distance_between_users_that_identically_rated_same_movies_will_be_1
        assert_equal 1, @sut.euclidean_distance(EXISTING_USER_1, EXISTING_USER_1)
        assert_equal 1, @sut.euclidean_distance(EXISTING_USER_1, EXISTING_USER_1_WITH_MORE_RATED_MOVIES)
        assert_equal 1, @sut.euclidean_distance(EXISTING_USER_1_WITH_MORE_RATED_MOVIES, EXISTING_USER_1)
    end

    def test_that_euclidean_distance_gives_correct_distance_between_two_random_users
        assert_in_delta 0.29429, @sut.euclidean_distance(EXISTING_USER_1, EXISTING_USER_2), 0.00001
        assert_in_delta 0.29429, @sut.euclidean_distance(EXISTING_USER_2, EXISTING_USER_1), 0.00001
    end

    def test_that_when_any_of_the_users_is_not_in_database_then_pearson_distance_will_be_0
        assert_equal 0, @sut.pearson_distance(NONEXISTING_USER_1, NONEXISTING_USER_2)
        assert_equal 0, @sut.pearson_distance(EXISTING_USER_1, NONEXISTING_USER_1)
        assert_equal 0, @sut.pearson_distance(NONEXISTING_USER_1, EXISTING_USER_1)
    end

    def test_that_when_users_have_no_mutualy_rated_movies_then_pearson_distance_will_be_0
        assert_equal 0, @sut.pearson_distance(EXISTING_EMPTY_USER, EXISTING_USER_1)
        assert_equal 0, @sut.pearson_distance(EXISTING_USER_1, EXISTING_EMPTY_USER)
    end

    def test_that_pearson_distance_between_users_that_identically_rated_same_movies_will_be_1
        assert_equal 1, @sut.pearson_distance(EXISTING_USER_1, EXISTING_USER_1)
        assert_equal 1, @sut.pearson_distance(EXISTING_USER_1, EXISTING_USER_1_WITH_MORE_RATED_MOVIES)
        assert_equal 1, @sut.pearson_distance(EXISTING_USER_1_WITH_MORE_RATED_MOVIES, EXISTING_USER_1)
    end

    def test_that_pearson_distance_between_users_that_have_shifted_movie_scores_will_be_1
        assert_equal 1, @sut.pearson_distance(EXISTING_USER_1, EXISTING_USER_1_WITH_SCORES_SHIFTED_BY_CONSTANT)
        assert_equal 1, @sut.pearson_distance(EXISTING_USER_1_WITH_SCORES_SHIFTED_BY_CONSTANT, EXISTING_USER_1)
    end

    def test_that_pearson_distance_gives_correct_distance_between_two_random_users
        assert_in_delta 0.39605, @sut.pearson_distance(EXISTING_USER_1, EXISTING_USER_2), 0.00001
        assert_in_delta 0.39605, @sut.pearson_distance(EXISTING_USER_2, EXISTING_USER_1), 0.00001
    end

    def test_that_when_any_of_the_users_is_not_in_database_then_tanimoto_distance_will_be_0
        assert_equal 0, @sut.tanimoto_distance(NONEXISTING_USER_1, NONEXISTING_USER_2)
        assert_equal 0, @sut.tanimoto_distance(EXISTING_USER_1, NONEXISTING_USER_1)
        assert_equal 0, @sut.tanimoto_distance(NONEXISTING_USER_1, EXISTING_USER_1)
    end

    def test_that_when_users_have_no_mutualy_rated_movies_then_tanimoto_distance_will_be_0
        assert_equal 0, @sut.tanimoto_distance(EXISTING_EMPTY_USER, EXISTING_USER_1)
        assert_equal 0, @sut.tanimoto_distance(EXISTING_USER_1, EXISTING_EMPTY_USER)
    end

    def test_that_tanimoto_distance_between_users_that_identically_rated_same_movies_will_be_1
        assert_equal 1, @sut.tanimoto_distance(EXISTING_USER_1, EXISTING_USER_1)
        assert_equal 1, @sut.tanimoto_distance(EXISTING_USER_1, EXISTING_USER_1_WITH_MORE_RATED_MOVIES)
        assert_equal 1, @sut.tanimoto_distance(EXISTING_USER_1_WITH_MORE_RATED_MOVIES, EXISTING_USER_1)
    end

    def test_that_tanimoto_distance_gives_correct_distance_between_two_random_users
        assert_in_delta 0.33333, @sut.tanimoto_distance(EXISTING_USER_1, EXISTING_USER_2), 0.00001
        assert_in_delta 0.33333, @sut.tanimoto_distance(EXISTING_USER_2, EXISTING_USER_1), 0.00001
    end
end
