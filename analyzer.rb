class Analyzer
    ALL_NEIGHBOURS = ["all"]
    def initialize(results, n_neighbours: ALL_NEIGHBOURS)
        @results = results
        @n_neighbours = n_neighbours
    end

    def get_average_times
        result = {}
        result[:system_generation_time] = get_average_system_generation_time
        result[:recommendation_generation_time] = {}
        @n_neighbours.each do |n|
            result[:recommendation_generation_time][n] = get_average_recommendation_generation_time(n)
        end

        result
    end

    def get_time_standard_deviations
        result = {}
        result[:system_generation_time] = get_system_generation_time_standard_deviation
        result[:recommendation_generation_time] = {}
        @n_neighbours.each do |n|
            result[:recommendation_generation_time][n] = get_recommendation_generation_time_standard_deviation(n)
        end

        result
    end

    def get_mean_square_error
        result = {}
        @n_neighbours.each do |n|
            number_of_predictions = get_number_of_predictions(n)
            if number_of_predictions == 0
                result[n] = "brak predykcji"
            else
                result[n] = Math.sqrt(get_sum_of_square_errors(n) / number_of_predictions.to_f)
            end
        end

        result
    end

    private
    def get_average_system_generation_time
        sum_of_times = @results.inject(0) do |sum, fold_result|
            sum + fold_result[:system_generation_time]
        end

        sum_of_times / @results.size.to_f
    end

    def get_average_recommendation_generation_time(n)
        sum_of_times = @results.inject(0) do |sum, fold_result|
            sum + fold_result[n][:calculation_results].values.inject(0) do |fold_sum, user_results|
                fold_sum + user_results[:time_of_recommendation_generation]
            end
        end

        sum_of_times / get_number_of_generations(n).to_f
    end

    def get_system_generation_time_standard_deviation
        average_system_generation_time = get_average_system_generation_time
        numerator = @results.inject(0) do |sum, fold_result|
            sum + (fold_result[:system_generation_time] - average_system_generation_time)**2
        end

        Math.sqrt(numerator / (@results.size.to_f - 1))
    end

    def get_recommendation_generation_time_standard_deviation(n)
        average_recommendation_generation_time = get_average_recommendation_generation_time(n)
        numerator = @results.inject(0) do |sum, fold_result|
            sum + fold_result[n][:calculation_results].values.inject(0) do |fold_sum, user_results|
                fold_sum + (user_results[:time_of_recommendation_generation] - average_recommendation_generation_time)**2
            end
        end

        Math.sqrt(numerator / (get_number_of_generations(n).to_f - 1))
    end

    def get_number_of_predictions(n)
        @results.inject(0) do |sum, fold_result|
            sum + fold_result[n][:calculation_results].inject(0) do |fold_sum, (_, user_results)|
                fold_sum + user_results[:filtered_rated_objects].inject(0) do |user_sum, (rated_object, _)|
                    if user_results[:recommendations][rated_object].nil?
                        user_sum
                    else
                        user_sum + 1
                    end
                end
            end
        end
    end

    def get_sum_of_square_errors(n)
        @results.inject(0) do |sum, fold_result|
            sum + fold_result[n][:calculation_results].inject(0) do |fold_sum, (_, user_results)|
                fold_sum + user_results[:filtered_rated_objects].inject(0) do |user_sum, (rated_object, rate)|
                    if user_results[:recommendations][rated_object].nil?
                        user_sum
                    else
                        user_sum + (user_results[:recommendations][rated_object] - rate)**2
                    end
                end
            end
        end
    end

    def get_number_of_generations(n)
        @results.inject(0) do |sum, fold_result|
            sum + fold_result[n][:calculation_results].size
        end
    end
end
