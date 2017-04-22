module Helper
    class Logger
        attr_writer :fold, :removal_factor, :recommendation_system

        def puts_state_informations
            Kernel.send(:puts, "removal factor: #{@removal_factor}, fold: #{@fold}, system: #{@recommendation_system}")
        end

        def puts_with_state_informations(msg)
            Kernel.send(:puts, "removal factor: #{@removal_factor}, fold: #{@fold}, system: #{@recommendation_system}, info: #{msg}")
        end

        def puts(msg)
            Kernel.send(:puts, "info: #{msg}")
        end
    end
end
