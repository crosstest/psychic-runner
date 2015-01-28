module Crosstest
  class Psychic
    class ScriptFactory < FactoryManager
      include Crosstest::Core::Logger

      TASK_PRIORITY = 5

      attr_reader :priority, :psychic, :run_patterns

      class << self
        def register_script_factory
          Crosstest::Psychic::ScriptFactoryManager.register_factory(self)
        end

        def run_patterns
          @run_patterns ||= {}
        end

        def runs(ext, priority = 5)
          run_patterns[ext] = priority
        end

        def priority_for(code_sample)
          code_sample_path = Pathname(code_sample)
          run_patterns.each do | pattern, priority |
            return priority if code_sample_path.fnmatch(pattern, File::FNM_CASEFOLD)
          end
          nil
        end
      end

      def initialize(psychic, opts)
        @psychic = psychic
        @opts = opts
        @logger = opts[:logger] || new_logger
      end

      def active?
        true
      end

      def known_scripts
        cwd_path = Pathname(psychic.cwd)
        self.class.run_patterns.flat_map do | pattern, _priority |
          Dir[cwd_path.join(pattern)]
        end
      end

      def known_script?(script)
        known_scripts.include? Pathname(script)
      end

      def priority_for_script(code_sample)
        self.class.priority_for(code_sample)
      end

      def command_for_sample(_code_sample)
        fail NotImplementedError, 'This should be implemented by subclasses'
      end
    end
  end
end
