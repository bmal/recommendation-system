require_relative '../analyzer'
require 'minitest/autorun'
require 'minitest/ci'

class AnalyzerTestSuite < MiniTest::Test
    RESULTS = [
        {
            system_generation_time: 10,
            calculation_results: {
                "A" => {
                    time_of_recommendation_generation: 5,
                    recommendations: {
                        "Toy Story" => 3.5,
                        "Godfather" => 4,
                        "House of cards" => 5,
                        "Doom" => 3,
                        "Seven" => 3.5,
                        "Fight club" => 2
                    },
                    filtered_rated_objects: {
                        "Godfather" => 5,
                        "Dexter" => 3,
                        "House of cards" => 4.5
                    }
                },
                "B" => {
                    time_of_recommendation_generation: 7,
                    recommendations: {
                        "Toy Story" => 5,
                        "Godfather" => 4.5,
                        "Harry Potter" => 2,
                        "Fight club" => 3,
                        "Seven" => 5
                    },
                    filtered_rated_objects: {
                        "Seven" => 2,
                        "Toy Story" => 5
                    }
                }
            }
        },
        {
            system_generation_time: 4,
            calculation_results: {
                "A" => {
                    time_of_recommendation_generation: 7,
                    recommendations: {
                        "Toy Story" => 3.5,
                        "Godfather" => 2,
                        "Seven" => 5,
                        "Dexter" => 2.5,
                        "Fight club" => 2
                    },
                    filtered_rated_objects: {
                        "Godfather" => 5,
                        "Dexter" => 3,
                        "House of cards" => 4.5
                    }
                },
                "B" => {
                    time_of_recommendation_generation: 4,
                    recommendations: {
                        "Toy Story" => 3,
                        "Godfather" => 4,
                        "Harry Potter" => 4,
                        "Fight club" => 2
                    },
                    filtered_rated_objects: {
                        "Seven" => 2,
                        "Toy Story" => 5
                    }
                }
            }
        }
    ]

    def setup
        @sut = Analyzer.new(RESULTS)
    end

    def test_that_the_average_time_of_recommendation_generation_is_calculated_correctly
        assert_in_delta 5.75, (@sut.get_average_times)[:recommendation_generation_time], 0.01
    end

    def test_that_the_average_time_of_system_creation_is_calculated_correctly
    end

    def test_that_the_standard_deviation_of_recommendation_generation_is_calculated_correctly
    end

    def test_that_the_standard_deviation_of_system_creation_is_calculated_correctly
    end

    def test_that_the_mean_square_error_is_calculated_correctly
    end
end
