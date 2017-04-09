class Logger
    def puts(msg)
        Kernel.send(:puts, msg)
    end
end
