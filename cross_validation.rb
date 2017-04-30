class WrongNumberOfFolds < StandardError
end

class DataSetTooSmall < StandardError
end

class CrossValidation
    include Enumerable

    def initialize(prefs, number_of_folds, seed: 124)
        if number_of_folds < 1
            raise WrongNumberOfFolds.new("Number of folds must be greater than 0")
        elsif prefs.size >= 2*number_of_folds
            @number_of_folds = number_of_folds
            @seed = seed

            chunks = split_into_equal_chunks(prefs)
            @traning_and_testing_sets_for_each_fold = split_chunks_into_testing_and_training_sets(chunks)
        else
            raise DataSetTooSmall.new("Current size of data set: #{prefs.size}, minimal size of data set for \
                                      #{number_of_folds} folds cross validation: #{2*number_of_folds}")
        end
    end

    def each
        return @traning_and_testing_sets_for_each_fold.to_enum(:each) unless block_given?

        @traning_and_testing_sets_for_each_fold.each { |elem| yield(elem) }
    end

    private
    def split_into_equal_chunks(prefs)
        shuffled_prefs = prefs.to_a.shuffle(random: Random.new(@seed))
        chunk_size = prefs.size / @number_of_folds
        chunks = shuffled_prefs.each_slice(chunk_size).to_a

        if chunks.last.size != chunks[chunks.size - 2].size
            chunks.pop
        end

        chunks.map { |chunk| chunk.to_h }
    end

    def split_chunks_into_testing_and_training_sets(chunks)
        chunks.map.with_index do |chunk|
            training_set = chunks - [chunk]
            {testing_set: chunk, training_set: training_set.inject(:merge)}
        end
    end
end
