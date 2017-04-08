class Benchmark
    def initialize(folds, seed: 152)
        @folds = folds
        @seed = seed
    end

    def perform(removal_factor: 0.3, &recommendation_system_creator)
        results = []

        @folds.each do |fold|
            fold_results = {}
            data_set, filtered_objects = prepare_data_set(fold, removal_factor)

            fold_results[:system_generation_time], recommendation_system  = count_time_and_perform { recommendation_system_creator.call(data_set) }

            users = fold[:testing_set].keys
            fold_results[:calculation_results] = {}
            users.each do |user|
                time_of_recommendation_generation, recommendations_list = count_time_and_perform { recommendation_system.calculate_recommendations(user) }
                fold_results[:calculation_results][user] = {
                    time_of_recommendation_generation: time_of_recommendation_generation,
                    recommendations: recommendations_list,
                    filtered_rated_objects: filtered_objects[user] }
            end

            results << fold_results
        end

        results
    end

    private
    def count_time_and_perform(&operation)
        starting_time = Time.now
        result = operation.call
        ending_time = Time.now 

        [ending_time - starting_time, result]
    end

    def prepare_data_set(fold, removal_factor)
        filtered_testing_set, removed_objects = filter_testing_set(fold[:testing_set], removal_factor)
        data_set = fold[:training_set].merge(filtered_testing_set)

        [data_set, removed_objects]
    end

    def filter_testing_set(original_testing_set, removal_factor)
        new_training_set = {}
        removed_elements = {}

        original_testing_set.each do |user, ratings|
            shuffled_ratings = ratings.to_a.shuffle(random: Random.new(@seed))
            num_of_elements_to_remove = shuffled_ratings.size * removal_factor

            new_training_set[user] = shuffled_ratings[num_of_elements_to_remove...shuffled_ratings.size].to_h
            removed_elements[user] = shuffled_ratings[0...num_of_elements_to_remove].to_h.keys
        end

        [new_training_set, removed_elements]
    end
end
