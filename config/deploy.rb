set :application      , 'blogy'
set :database_file    , "#{deploy_to}/config/database.yml"
set :log_level        , :info
set :repo_url         , 'git@github.com:wbotelhos/blogy'
set :secrets_file     , "#{current_path}/config/secrets.yml"
set :unicorn_file     , "#{deploy_to}/config/unicorn.rb"
set :unicorn_pid_file , "#{shared_path}/pids/unicorn.pid"

namespace :app do
  task :secret_key do
    on roles :app do
      info ': Filling secrets.yml...'

      key = %x(bundle exec rake secret).gsub /\n/, ''

      execute %(echo 'production:' > #{fetch(:secrets_file)} && echo "  secret_key_base: #{key}" >> #{fetch(:secrets_file)})
    end
  end

  task :setup do
    on roles :app do
      info ': Linking database.yml...'

      %w[config/database.yml].each do |path|
        from = "#{deploy_to}/#{path}"
        to   = "#{current_path}/#{path}"

        execute :rm, '-f', to
        execute :ln, '-s', from, to
      end
    end
  end
end

namespace :labs do
  task :cold do
    on roles :app do
      execute :mkdir, '-p', '~/workspace'
      execute :ln, '-sf', current_path, '~/workspace/blogy'
    end
  end

  task :link do
    on roles :app do
      within current_path do
        execute 'script/labs/link.sh'
      end
    end
  end

  task :pull do
    on roles :app do
      within current_path do
        execute 'script/labs/pull.sh'
      end
    end
  end

  task :setup do
    on roles :app do
      within current_path do
        execute 'script/labs/setup.sh'
      end
    end
  end
end

namespace :unicorn do
  task :restart do
    on roles :app do
      invoke 'unicorn:stop'
      invoke 'unicorn:start'
    end
  end

  task :start do
    on roles :app do
      within current_path do
        if test unicorn_pid_exist? && unicorn_running?
          info ': Unicorn is already running.'
        else
          info ': Unicorn starting...'

          with rails_env: fetch(:rails_env) do
            execute :bundle, 'exec unicorn_rails', '-c', fetch(:unicorn_file), '-D'
          end
        end
      end
    end
  end

  task :stop do
    on roles :app do
      within current_path do
        if test unicorn_pid_exist?
          if test unicorn_running?
            info ': Unicorn stopping...'
            execute :kill, unicorn_pid
          else
            info ': Unicorn PID was dead. Removing it...'
            execute :rm, fetch(:unicorn_pid_file)
          end
        else
          info ': Unicorn is already stopped.'
        end
      end
    end
  end
end

after 'deploy:finished', 'app:setup'
after 'deploy:finished', 'app:secret_key'
after 'deploy:finished', 'labs:setup'
after 'deploy:finished', 'unicorn:restart'

def unicorn_pid
  "`cat #{fetch(:unicorn_pid_file)}`"
end

def unicorn_pid_exist?
  "[ -e #{fetch(:unicorn_pid_file)} ]"
end

def unicorn_running?
  "kill -0 #{unicorn_pid}"
end
