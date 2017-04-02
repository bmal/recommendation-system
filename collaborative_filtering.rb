class CollaborativeFiltering
    public
    def initialize(prefs, correlation_coefficient_calculator, similarity_threshold = 0)
        @prefs = prefs
        @correlation_coefficient_calculator = correlation_coefficient_calculator
        @similarity_threshold = similarity_threshold
    end

    def calculate_recommendations(user)
        other_similar_users = get_other_similar_users(user)

        weighted_object_values = {}
        weighted_object_values.default = 0

        sum_of_weights_per_object = {}
        sum_of_weights_per_object.default = 0

        other_similar_users.each do |other_user|
            sim = @correlation_coefficient_calculator.calculate_similarity(user, other_user)
            unrated_object_by_user = get_objects_rated_only_by_first_user(user_who_rated: other_user, user_who_did_not_rate: user)

            unrated_object_by_user.each do |object, rating|
                weighted_object_values[object] += rating*sim
                sum_of_weights_per_object[object] += sim
            end
        end

        weighted_object_values.map { |object, value| [object, value/sum_of_weights_per_object[object]] }
            .sort_by { |_, rating| rating }
            .reverse.to_h
    end

    private
    def get_other_similar_users(user)
        other_users_and_objects_rated_by_them = @prefs.select do |other_user, _|
            other_user != user && @correlation_coefficient_calculator.calculate_similarity(user, other_user) > @similarity_threshold
        end
        other_users_and_objects_rated_by_them.keys
    end

    def get_objects_rated_only_by_first_user(user_who_rated:, user_who_did_not_rate:)
        @prefs[user_who_rated].select { |object_name, _| !@prefs[user_who_did_not_rate].keys.include?(object_name) }
    end
end
