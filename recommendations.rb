require_relative 'critics'
require_relative 'correlation_coefficient'
require_relative 'read_movie_lens'

class Recommendation
    public
    def initialize(prefs)
        @prefs = prefs
        @cc = CorrelationCoefficient.new(@prefs)
        recalculate_similar_movies
    end

    def top_critics(person, similarity = @cc.method(:sim_pearson))
        reviewers = @prefs.reject { |reviewer, _| reviewer == person }.to_h.keys
        reviewers.map { |reviewer| [reviewer, similarity.call(person, reviewer)] }
            .sort_by { |_, v| v }.reverse.to_h
    end

    def top_similar_movies(movie, similarity = @cc.method(:sim_pearson))
        transform_prefs
        critics = top_critics(movie, similarity)
        transform_prefs
        critics
    end

    def get_recommendation_ranking_based_on_users(person, similarity = @cc.method(:sim_pearson))
        valuable_critics = @prefs.select { |critic, _| critic != person && similarity.call(person, critic) > 0 }.keys

        weighted_movie_values = {}
        weighted_movie_values.default = 0

        sum_of_weights_per_movie = {}
        sum_of_weights_per_movie.default = 0

        valuable_critics.each do |critic|
            sim = similarity.call(person, critic)
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

    def get_recommended_critics(movie, similarity = @cc.method(:sim_pearson))
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
        @cc.prefs = @prefs
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
            [movie, top_similar_movies(movie, @cc.method(:sim_distance))]
        end.to_h
    end

    def get_all_movies
        transform_prefs
        movies = @prefs.keys
        transform_prefs
        movies
    end
end

r = Recommendation.new($critics)
puts r.get_recommendation_ranking_based_on_users("Toby")
puts r.top_similar_movies("Nocny słuchacz")
puts r.get_recommended_critics("Całe szczęście")
#puts r.get_recommendation_ranking_based_on_items("Toby")

puts "-------------"

prefs = get_prefs('../movielens/u.data')
prefs["Bartek"] ={}
prefs["Bartek"]["Taxi Driver"] = 3
prefs["Bartek"]["Shawshank Redemption, The"] = 5
prefs["Bartek"]["Pulp Fiction"] = 5
prefs["Bartek"]["Shining, The"] = 4
prefs["Bartek"]["Silence of the Lambs, The"] = 4
prefs["Bartek"]["Ace Ventura: Pet Detective"] = 1
r = Recommendation.new(prefs)
p r.get_recommendation_ranking_based_on_users("Bartek").take(5)
p r.get_recommendation_ranking_based_on_items("Bartek").take(5)
