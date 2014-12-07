require 'bundler/capistrano'

set :application, 'wbotelhos.com'

set :branch        , 'master'
set :deploy_via    , :remote_cache
set :keep_releases , 2
set :repository    , 'git@github.com:wbotelhos/blogy'
set :scm           , :git

set :group  , 'ubuntu'
set :runner , 'ubuntu'
set :user   , 'ubuntu'

set :use_sudo, false

set :deploy_to , '/var/www/blogy'
set :current   , "#{deploy_to}/current"

role :app , application
role :db  , application, primary: true
role :web , application

default_run_options[:pty] = true

ssh_options[:forward_agent] = true
ssh_options[:keys]          = '~/.ssh/wbotelhos.pem'

after :deploy, 'deploy:cleanup'

namespace :deploy do
  task :default do
    update
    app.setup
    assets.precompile
    app.secret_key
    labs.link
    app.restart
  end
end

namespace :app do
  task :restart do
    stop
    start
  end

  task :secret_key do
    file       = "#{current}/config/secrets.yml"
    secret_key = %x(bundle exec rake secret).gsub(/\n/, '')

    run %(echo 'production:' > #{file} && echo "  secret_key_base: #{secret_key}" >> #{file})
  end

  task :setup do
    %w[config/database.yml].each do |path|
      from = "#{deploy_to}/#{path}"
      to   = "#{current}/#{path}"

      run "if [ -f '#{to}' ]; then rm '#{to}'; fi; ln -s #{from} #{to}"
    end
  end

  task :start do
    run "cd #{current} && GEM_HOME=/usr/local/ruby/gems && RAILS_ENV=production bundle exec unicorn_rails -c #{deploy_to}/config/unicorn.rb -D"
  end

  task :stop do
    run "if [ -f #{shared_path}/pids/unicorn.pid ]; then kill `cat #{shared_path}/pids/unicorn.pid`; fi"
  end
end

namespace :assets do
  task :precompile do
    %x(RAILS_ENV=production bundle exec rake assets:precompile)
  end
end

namespace :labs do
  task :cold do
    run %(mkdir -p ~/workspace)
    run %(ln -s #{current} ~/workspace/blogy)
  end

  task :link do
    run %(cd #{current} && script/labs/link.sh)
  end

  task :pull do
    run %(cd #{current} && script/labs/pull.sh)
  end

  task :setup do
    run %(cd #{current} && script/labs/setup.sh)
  end
end
