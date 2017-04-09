require_relative 'recommendation_system_factory'
require_relative 'correlation_coefficient_factory'
require_relative 'movie_lens_100k_reader'
require_relative 'test/test_helper'
require_relative 'cross_validation'
require_relative 'benchmark'

class Analyzer
    def initialize(results)
        @results = results
    end

    def get_average_times
        {system_generation_time: get_average_system_generation_time,
         recommendation_generation_time: get_average_recommendation_generation_time}
    end

    def get_time_standard_deviations
        {system_generation_time: get_system_generation_time_standard_deviation,
         recommendation_generation_time: get_recommendation_generation_time_standard_deviation}
    end

    def get_mean_square_error
        Math.sqrt(get_sum_of_square_errors / get_number_of_predictions)
    end

    private
    def get_average_system_generation_time
        sum_of_times = @results.inject(0) do |sum, fold_result|
            sum + fold_result[:system_generation_time]
        end

        sum_of_times / @results.size
    end

    def get_average_recommendation_generation_time
        sum_of_times = @results.inject(0) do |sum, fold_result|
            sum_of_fold_times = fold_result[:calculation_results].values.inject(0) do |fold_sum, instance_results|
                fold_sum + instance_results[:time_of_recommendation_generation]
            end

            average_fold_time = sum_of_fold_times / fold_result.size
            sum + average_fold_time
        end

        sum_of_times / @results.size
    end

    def get_system_generation_time_standard_deviation
        average_system_generation_time = get_average_system_generation_time
        numerator = @results.inject(0) do |sum, fold_result|
            sum + (fold_result[:system_generation_time] - average_system_generation_time)**2
        end

        Math.sqrt(numerator / @results.size)
    end

    def get_recommendation_generation_time_standard_deviation
        number_of_generations = @results.inject(0) do |sum, fold_result|
            sum + fold_result[:calculation_results].size
        end

        average_recommendation_generation_time = get_average_recommendation_generation_time
        numerator = @results.inject(0) do |sum, fold_result|
            sum + fold_result[:calculation_results].values.inject(0) do |fold_sum, instance_results|
                fold_sum + (instance_results[:time_of_recommendation_generation] - average_recommendation_generation_time)**2
            end
        end

        Math.sqrt(numerator / number_of_generations)
    end

    def get_number_of_predictions
        @results.inject(0) do |sum, fold_result|
            sum + fold_result[:calculation_results].inject(0) do |fold_sum, (_, instance_results)|
                fold_sum + instance_results[:filtered_rated_objects].size
            end
        end
    end

    def get_sum_of_square_errors
        @results.inject(0) do |sum, fold_result|
            sum + fold_result[:calculation_results].inject(0) do |fold_sum, (_, instance_results)|
                fold_sum + instance_results[:filtered_rated_objects].inject(0) do |instance_sum, (predicted_object, prediction)|
                    if instance_results[:recommendations][predicted_object].nil?
                        instance_sum + (prediction)**2
                    else
                        instance_sum + (instance_results[:recommendations][predicted_object] - prediction)**2
                    end
                end
            end
        end
    end
end

prefs = TestHelper::CRITICS #MovieLens100kReader.new.get_prefs
similarity = CorrelationCoefficientFactory.new(prefs).createTanimotoSimilarity
b = Benchmark.new(CrossValidation.new(prefs, 2))

results = b.perform do |fold|
    RecommendationSystemFactory.new(fold, similarity).createContentBasedFilteringSystem
end

a = Analyzer.new(results)
p a.get_mean_square_error
