require_relative 'recommendation_system_factory'
require_relative 'correlation_coefficient_factory'
require_relative 'test/test_helper'
require_relative 'cross_validation'
require_relative 'benchmark'
require_relative 'logger'
require_relative 'percent_printer'

class Experimenter
    DUMMY_DATA = TestHelper::CRITICS

    def initialize(logger: Logger.new,
                   n_neighbours: [5, 25, 125, 625],
                   correlation_coefficient_factory_creator: Proc.new { |prefs| CorrelationCoefficientFactory.new(prefs) },
                   recommendation_system_factory_creator: Proc.new do |prefs, correlation_coefficient_calculator, percent_printer|
                       RecommendationSystemFactory.new(prefs, correlation_coefficient_calculator, percent_printer)
                   end)
        @logger = logger
        @n_neighbours = n_neighbours
        @correlation_coefficient_factory_creator = correlation_coefficient_factory_creator
        @recommendation_system_factory_creator = recommendation_system_factory_creator
    end

    def perform_tests_and_generate_report(number_of_folds: 10, &data_set_generator)
        prefs = yield
        @logger.puts "data set created"

        correlation_coefficient_generators = generate_correlation_coefficient_generators
        recommendation_system_generators = generate_recommendation_systems(correlation_coefficient_generators)

        reports = {}

        benchmark = Benchmark.new(CrossValidation.new(prefs, number_of_folds), logger: @logger)

        (1...10).each do |removal_efficient|
            if removal_efficient.odd?
                removal_factor = removal_efficient * 0.1
                @logger.removal_factor = removal_factor
                reports[removal_factor] = recommendation_system_generators.map do |name, generator|
                    [name, benchmark.generate_report(recommendation_system_creator: generator,
                                                    removal_factor: removal_factor,
                                                    n_neighbours: @n_neighbours)]
                end.to_h
            end
        end

        reports
    end

    private
    def generate_correlation_coefficient_generators
        @correlation_coefficient_factory_creator.call(DUMMY_DATA).methods.grep(/create_/).map do |factory_method|
            object_name = factory_method.to_s.match(/create_(\w+)/).captures.first

            [object_name,
             Proc.new do |fold|
                factory = @correlation_coefficient_factory_creator.call(fold)
                coefficient = factory.public_send(factory_method)
                coefficient
            end]
        end.to_h
    end

    def generate_recommendation_systems(correlation_coefficient_generators)
        recommendation_systems = {}
        correlation_coefficient_generators.each do |(coefficient_name, coefficient)|
            @recommendation_system_factory_creator.call(DUMMY_DATA, coefficient.call(DUMMY_DATA), Object.new).methods.grep(/create_/).each do |factory_method|
                object_name = factory_method.to_s.match(/create_(\w+)/).captures.first + "_" + coefficient_name

                recommendation_systems[object_name] = Proc.new do |fold|
                    @logger.recommendation_system = object_name
                    @logger.puts_state_informations

                    factory = @recommendation_system_factory_creator.call(fold, coefficient.call(fold), PercentPrinter.new(@logger))
                    recommendation_system = factory.public_send(factory_method)
                    recommendation_system 
                end
            end
        end

        recommendation_systems
    end
end
