class Recommendation
    public
    def initialize(prefs, correlation_coefficient_calculator)
        @prefs = prefs
        recalculate_similar_movies
    end

    def top_critics(person)
        reviewers = @prefs.reject { |reviewer, _| reviewer == person }.to_h.keys
        reviewers.map { |reviewer| [reviewer, @correlation_coefficient_calculator.calculate_similarity(person, reviewer)] }
            .sort_by { |_, v| v }.reverse.to_h
    end

    def top_similar_movies(movie)
        transform_prefs
        critics = top_critics(movie, similarity)
        transform_prefs
        critics
    end

    def get_recommendation_ranking_based_on_users(person)
        valuable_critics = @prefs.select { |critic, _| critic != person && @correlation_coefficient_calculator.calculate_similarity(person, critic) > 0 }.keys

        weighted_movie_values = {}
        weighted_movie_values.default = 0

        sum_of_weights_per_movie = {}
        sum_of_weights_per_movie.default = 0

        valuable_critics.each do |critic|
            sim = @correlation_coefficient_calculator.calculate_similarity(person, critic)
            unseen_movies_by_person = @prefs[critic].select { |movie, _| !@prefs[person].keys.include?(movie) }

            unseen_movies_by_person.each do |movie, rating|
                weighted_movie_values[movie] += rating*sim
                sum_of_weights_per_movie[movie] += sim
            end
        end

        weighted_movie_values.map { |movie, value| [movie, value/sum_of_weights_per_movie[movie]] }
            .sort_by { |_, rating| rating }
            .reverse.to_h.keys
    end

    def get_recommended_critics(movie)
        transform_prefs
        critics = get_recommendation_ranking_based_on_users(movie, similarity)
        transform_prefs
        critics
    end

    def get_recommendation_ranking_based_on_items(person)
        unseen_movies = get_all_movies.reject { |movie| @prefs[person].has_key? movie }
        seen_movies = @prefs[person].keys

        unseen_movies.map do |unseen_movie|
            movie_weight = seen_movies.inject(0) { |sum, seen_movie| sum + @movies_similarity[unseen_movie][seen_movie] }
            movie_value = seen_movies.inject(0) { |sum, seen_movie| sum + @movies_similarity[unseen_movie][seen_movie]*@prefs[person][seen_movie] }
            [unseen_movie, movie_value/(1 + movie_weight)]
        end.sort_by { |_, weighted_value| weighted_value }.reverse.to_h.keys
    end

    private
    def transform_prefs
        opinions = {}
        @prefs.each do |person, films|
            films.each do |film, rating|
                opinions[film] = {} unless opinions.has_key? film
                opinions[film][person] = rating
            end
        end

        @prefs = opinions
        @correlation_coefficient_calculator.prefs = @prefs
    end

    def recalculate_similar_movies
        size = get_all_movies.size
        percent = (size/100).to_i
        actual = -1 
        @movies_similarity = get_all_movies.map.with_index do |movie, index|
            if percent != 0 && index % percent == 0
                actual += 1
                puts "#{actual}%"
            end
            [movie, top_similar_movies(movie, @correlation_coefficient_calculator.method(:sim_distance))]
        end.to_h
    end

    def get_all_movies
        transform_prefs
        movies = @prefs.keys
        transform_prefs
        movies
    end
end
