require_relative 'no_such_user_exception'

class ContentBasedFiltering
    public
    def initialize(prefs, correlation_coefficient_calculator, percent_printer, similarity_threshold = 0)
        @prefs = prefs
        @correlation_coefficient_calculator = correlation_coefficient_calculator
        @percent_printer = percent_printer
        @similarity_threshold = similarity_threshold

        @percent_printer.set_size(get_all_rated_objects.size)
        @objects_and_sorted_similar_objects = recalculate_objects_neighbours
    end

    def calculate_recommendations(user, n_neighbours: 50)
        if @prefs[user].nil?
            raise NoSuchUserException.new("There is no user #{user}")
        end

        rated_objects = get_objects_rated_by_user(user)
        unrated_objects = get_objects_unrated_by_user(user)

        if unrated_objects.empty?
            return {}
        end

        similar_unrated_objects = get_nearest_objects_unrated_by_user(user, n_neighbours, rated_objects)

        reccomended_objects_and_predicted_ratings = similar_unrated_objects.map do |unrated_object|
            object_weight = rated_objects.inject(0) do |sum, rated_object|
                sum + @objects_and_sorted_similar_objects[unrated_object][rated_object]
            end

            object_value = rated_objects.inject(0) do |sum, rated_object|
                sum + @objects_and_sorted_similar_objects[unrated_object][rated_object]*@prefs[user][rated_object]
            end

            if object_weight != 0
                predicted_rating = object_value/(object_weight)
                [unrated_object, predicted_rating]
            else
                next 
            end
        end
        
        reccomended_objects_and_predicted_ratings.compact.sort_by { |_, rating| rating }.reverse.to_h
    end

    private
    def recalculate_objects_neighbours
        @percent_printer.restart
        get_all_rated_objects.map.with_index do |object, index|
            @percent_printer.print_percent("neighbours recalculation:", index)
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

    def get_objects_unrated_by_user(user)
        get_all_rated_objects.reject { |object| @prefs[user].has_key? object }
    end

    def get_nearest_objects_unrated_by_user(user, n_neighbours, rated_objects)
        rated_objects.map do |rated_object|
            @objects_and_sorted_similar_objects[rated_object].take(n_neighbours).to_h.keys
        end.flatten.uniq.reject { |object| rated_objects.include? object }
    end

    def get_objects_rated_by_user(user)
        @prefs[user].keys
    end
end
