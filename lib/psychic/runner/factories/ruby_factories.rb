module Psychic
  class Runner
    module Factories
      class BundlerTaskFactory < MagicTaskFactory
        TASK_PRIORITY = 2
        magic_file 'Gemfile'
        magic_file '.bundle/config'
        magic_env_var 'BUNDLE_GEMFILE'
        register_task_factory

        task :bootstrap do
          'bundle install'
        end

        task :run_sample do
          'bundle exec ruby {{sample_file}}'
        end
      end
    end
  end
end
