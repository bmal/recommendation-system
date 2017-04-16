require_relative 'no_such_user_exception'

class ContentBasedFiltering
    public
    def initialize(prefs, correlation_coefficient_calculator, similarity_threshold = 0)
        @prefs = prefs
        @correlation_coefficient_calculator = correlation_coefficient_calculator
        @similarity_threshold = similarity_threshold

        @objects_and_sorted_similar_objects = recalculate_objects_neighbours
    end

    def calculate_recommendations(user, n_neighbours: 50)
        rated_objects = @prefs[user]

        if rated_objects.nil?
            raise NoSuchUserException.new("There is no user #{user}")
        end

        scores = {}
        scores.default = 0
        similarities = {}
        similarities.default = 0

        rated_objects.each do |(rated_object, rating)|
            @objects_and_sorted_similar_objects[rated_object].take(n_neighbours).each do |(similar_object, similarity)|
                if rated_objects.include? similar_object
                    next
                end

                scores[similar_object] += similarity * rating
                similarities[similar_object] += similarity
            end
        end

        recommendations = {}
        scores.each do |(object, score)|
            recommendations[object] = score/similarities[object].to_f
        end

        recommendations.reject { |_, rating| rating.nan? }.sort_by { |(_, rating)| rating }.reverse.to_h
    end

    private
    def recalculate_objects_neighbours
        get_all_rated_objects.map.with_index do |object, index|
            [object, get_other_objects_with_similarity_coefficient(object)]
        end.to_h
    end

    def get_all_rated_objects
        transform_prefs
        all_objects = @prefs.keys
        transform_prefs
        all_objects 
    end

    def transform_prefs
        transformed_prefs = {}
        @prefs.each do |user, rated_objects|
            rated_objects.each do |rated_object, rating|
                transformed_prefs[rated_object] = {} unless transformed_prefs.has_key? rated_object
                transformed_prefs[rated_object][user] = rating
            end
        end

        @prefs = transformed_prefs
        @correlation_coefficient_calculator.prefs = transformed_prefs
    end

    def get_other_objects_with_similarity_coefficient(object)
        transform_prefs
        other_objects_and_similarity_coefficient = get_sorted_similar_objects(object)
        transform_prefs
        other_objects_and_similarity_coefficient
    end

    def get_sorted_similar_objects(object)
        objects_and_similarities = get_other_objects(object).map do |other_object|
            [other_object, @correlation_coefficient_calculator.calculate_similarity(object, other_object)]
        end

        objects_and_similarities.sort_by { |_, rating| rating }.reverse.to_h
    end

    def get_other_objects(object)
        @prefs.reject { |other_object, _| other_object == object }.to_h.keys
    end
end
