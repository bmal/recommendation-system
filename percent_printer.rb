class PercentPrinter
    def initialize(logger)
        @logger = logger
    end

    def set_size(size)
        @size = size
        @current_percent = -1
    end

    def restart
        @current_percent = -1
    end

    def print_percent(msg, index)
        if @size != 0 && index != 0 && ((index.to_f / @size) * 100).to_i > @current_percent
            @current_percent = ((index.to_f / @size) * 100).to_i
            @logger.puts_with_state_informations "#{msg} #{@current_percent}%"
        end
    end
end
