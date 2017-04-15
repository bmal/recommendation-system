require_relative 'movie_lens_100k_reader'
require_relative 'experimenter'

class CsvPrinter
    def print_report(filename, report)
        File.open(filename, 'w') do |file|
            file.puts "System rekomendacyjny,Procent usuniętych elementów,Średni czas generowania systemu,Średni czas generowania rekomendacji,Odchylenie standardowe czasu generowania systemu,Odchylenie standardowe czasu generowania rekomendacji,Błąd średniokwadratowy"
            report.each do |(removal_factor, removal_factor_report)|
                removal_factor_report.each do |(recommendation_system_name, recommendation_system_report)|
                file.print "#{recommendation_system_name},#{removal_factor},#{recommendation_system_report.get_average_times[:system_generation_time]},#{recommendation_system_report.get_average_times[:recommendation_generation_time]},#{recommendation_system_report.get_time_standard_deviations[:system_generation_time]},#{recommendation_system_report.get_time_standard_deviations[:recommendation_generation_time]},#{recommendation_system_report.get_mean_square_error}"
                end
            end
        end
    end
end

e = Experimenter.new
report = e.perform_tests_and_generate_report(number_of_folds: 2) { TestHelper::CRITICS }

#printer = CsvPrinter.new
#printer.print_report("test.csv", report)
