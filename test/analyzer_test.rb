require_relative '../analyzer'
require 'minitest/autorun'
require 'minitest/ci'

class AnalyzerTestSuite < MiniTest::Test
    RESULTS = [
        {
            system_generation_time: 10,
            Analyzer::ALL_NEIGHBOURS.first => {
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
            }
        },
        {
            system_generation_time: 5,
            Analyzer::ALL_NEIGHBOURS.first => {
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
        }
    ]

    def setup
        @sut = Analyzer.new(RESULTS)
    end

    def test_that_the_average_time_of_recommendation_generation_is_calculated_correctly
        average_times = @sut.get_average_times

        assert_equal 1, average_times[:recommendation_generation_time].size
        assert_in_delta 5.75, average_times[:recommendation_generation_time][Analyzer::ALL_NEIGHBOURS.first], 0.00001
    end

    def test_that_the_average_time_of_system_creation_is_calculated_correctly
        assert_in_delta 7.5, @sut.get_average_times[:system_generation_time], 0.00001
    end

    def test_that_the_standard_deviation_of_recommendation_generation_is_calculated_correctly
        standard_deviations = @sut.get_time_standard_deviations

        assert_equal 1, @sut.get_time_standard_deviations[:recommendation_generation_time].size
        assert_in_delta 1.5, standard_deviations[:recommendation_generation_time][Analyzer::ALL_NEIGHBOURS.first], 0.00001
    end

    def test_that_the_standard_deviation_of_system_creation_is_calculated_correctly
        assert_in_delta 3.53553, @sut.get_time_standard_deviations[:system_generation_time], 0.00001
    end

    def test_that_the_mean_square_error_is_calculated_correctly
        mean_square_error = @sut.get_mean_square_error

        assert_equal 1, mean_square_error.size
        assert_in_delta 1.832250763, mean_square_error[Analyzer::ALL_NEIGHBOURS.first], 0.000000001
    end
end
