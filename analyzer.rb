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
        number_of_predictions = get_number_of_predictions
        if number_of_predictions == 0
            "brak predykcji"
        else
            Math.sqrt(get_sum_of_square_errors / get_number_of_predictions)
        end
    end

    private
    def get_average_system_generation_time
        sum_of_times = @results.inject(0) do |sum, fold_result|
            sum + fold_result[:system_generation_time]
        end

        sum_of_times / @results.size
    end

    def get_average_recommendation_generation_time
        number_of_generations = @results.inject(0) do |sum, fold_result|
            sum + fold_result[:calculation_results].size
        end

        sum_of_times = @results.inject(0) do |sum, fold_result|
            sum + fold_result[:calculation_results].values.inject(0) do |fold_sum, user_results|
                fold_sum + user_results[:time_of_recommendation_generation]
            end
        end

        sum_of_times / number_of_generations.to_f
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
