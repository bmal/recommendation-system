require_relative '../collaborative_filtering'
require_relative 'test_helper'
require 'minitest/autorun'
require 'minitest/ci'
require 'mocha/mini_test'

require_relative '../correlation_coefficient_factory'

class CollaborativeFilteringTestSuit < MiniTest::Test
    include TestHelper

    TESTED_USER = "Toby"
    DISSIMILAR_USERS = ["Lana Rose", "Robert Rose", "Gene Seymour", "Michael Phillips", "Claudia Puig", "Mick LeSalle", "Jack Matthews", "Donald Trump"]
    SIMILAR_USER = "Lisa Rose"
    VERY_SIMILAR_USER = "Bob Seymour"

    DISSIMILAR = 0
    SIMILAR = 0.5
    VERY_SIMILAR = 1

    def setup
        @correlation_coefficient_mock = mock
        @sut = CollaborativeFiltering.new(CRITICS, @correlation_coefficient_mock, DISSIMILAR)
    end

    def expect_one_similar_and_one_very_similar_user
        DISSIMILAR_USERS.each do |other_user|
            @correlation_coefficient_mock.stubs(:calculate_similarity).with(TESTED_USER, other_user).returns(DISSIMILAR)
        end

        @correlation_coefficient_mock.stubs(:calculate_similarity).with(TESTED_USER, SIMILAR_USER).returns(SIMILAR)
        @correlation_coefficient_mock.stubs(:calculate_similarity).with(TESTED_USER, VERY_SIMILAR_USER).returns(VERY_SIMILAR)
    end

    def test_that_full_list_of_reccomendations_is_calculated_correctly
        expect_one_similar_and_one_very_similar_user

        expected_result = {
            "Nocny słuchacz" => 3.0,
            "Kobieta w błękitnej wodzie" => 2.8333333333333335,
            "Dexter" => 2.5,
            "Całe szczęście" => 2.0}

        assert_equal expected_result, @sut.calculate_reccomendations(TESTED_USER)
    end
end
