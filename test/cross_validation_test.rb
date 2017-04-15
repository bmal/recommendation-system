require_relative '../cross_validation'
require 'minitest/autorun'
require 'minitest/ci'

class CrossValidationTestSuite < MiniTest::Test
    PREFS = {
        1 => {
            1 => 'a',
            2 => 'b' },
        2 => {
            3 => 'c' },
        3 => {
            1 => 'a',
            2 => 'b' },
        4 => {
            2 => 'b' },
        5 => {
            1 => 'a',
            2 => 'b' },
        6 => {
            1 => 'a',
            2 => 'b' },
        7 => {
            1 => 'a',
            2 => 'b' },
        8 => {
            1 => 'a',
            2 => 'b' },
        9 => {
            1 => 'a',
            2 => 'b' },
        10 => {
            1 => 'a',
            2 => 'b' }}

    EMPTY_PREFS = {}
    TOO_SMALL_PREFS = {
        1 => {
            1 => 'a',
            2 => 'b' },
        2 => {
            3 => 'c' },
        3 => {
            1 => 'a',
            2 => 'b' }}

    NUMBER_OF_FOLDS = 2
    SEED = 14
    TESTING_SET_FRACTION = 0.3

    def setup
        @sut = CrossValidation.new(PREFS, NUMBER_OF_FOLDS, seed: SEED, testing_set_fraction: TESTING_SET_FRACTION)
    end

    def create_sut_with_empty_prefs
        @sut = CrossValidation.new(EMPTY_PREFS, NUMBER_OF_FOLDS, seed: SEED, testing_set_fraction: TESTING_SET_FRACTION)
    end

    def create_sut_with_too_small_prefs
        @sut = CrossValidation.new(TOO_SMALL_PREFS, NUMBER_OF_FOLDS, seed: SEED, testing_set_fraction: TESTING_SET_FRACTION)
    end

    def create_sut_with_0_folds
        @sut = CrossValidation.new(PREFS, 0, seed: SEED, testing_set_fraction: TESTING_SET_FRACTION)
    end

    def test_that_cross_validation_constructor_will_throw_when_prefs_are_empty
        assert_raises(DataSetTooSmall) { create_sut_with_empty_prefs }
    end

    def test_that_cross_validation_constructor_will_throw_when_prefs_are_too_small
        assert_raises(DataSetTooSmall) { create_sut_with_too_small_prefs }
    end

    def test_that_cross_validation_constructor_will_throw_when_number_of_folds_is_lower_than_0
        assert_raises(WrongNumberOfFolds) { create_sut_with_0_folds }
    end

    def test_cross_validation
        chunks = @sut.each.to_a
        expected_chunks = [
            { :testing_set => {4 => {2 => "b"}},
              :training_set => {10 => {1 => "a", 2 => "b"}, 1 => {1 => "a", 2 => "b"}, 6 => {1 => "a", 2 => "b"}, 5 => {1 => "a", 2 => "b"}}},
            { :testing_set => {3 => {1 => "a", 2 => "b"}},
              :training_set => {2 => {3 => "c"}, 8 => {1 => "a", 2 => "b"}, 7 => {1 => "a", 2 => "b"}, 9 => {1 => "a", 2 => "b"}}}]
        assert_equal expected_chunks, chunks
    end
end
