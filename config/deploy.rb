require 'bundler/capistrano'

set :application, 'wbotelhos.com'

set :scm        , :git
set :repository , 'git@github.com:wbotelhos/wbotelhos-com.git'
set :branch     , 'master'
set :deploy_via , :remote_cache

set :user   , 'ubuntu'
set :runner , 'ubuntu'
set :group  , 'ubuntu'

set :use_sudo, false

set :deploy_to , '/var/www/wbotelhos'
set :current   , "#{deploy_to}/current"

role :web , application
role :app , application
role :db  , application, primary: true

default_run_options[:pty] = true

ssh_options[:forward_agent] = true
ssh_options[:keys]          = '~/.ssh/wbotelhos.pem'

after :deploy, 'deploy:cleanup'

namespace :deploy do
  task :default do
    update
    assets.precompile
    app.setup
    counter_cache.all
    app.restart
  end
end

namespace :app do
  task :start do
    run "cd #{current} && GEM_HOME=/opt/local/ruby/gems && RAILS_ENV=production bundle exec unicorn_rails -c #{deploy_to}/config/unicorn.rb -D"
  end

  task :stop do
    run "if [ -f #{shared_path}/pids/unicorn.pid ]; then kill `cat #{shared_path}/pids/unicorn.pid`; fi"
  end

  task :restart do
    stop
    start
  end
end

namespace :assets do
  assets_path   = '~/workspace/wbotelhos/public/assets'
  public_remote = "#{user}@#{application}:#{current}/public"

  task :precompile do
    %x(bundle exec rake assets:precompile)
    %x(rsync -e "ssh -i ${HOME}/.ssh/wbotelhos.pem" --archive --compress --progress #{assets_path} #{public_remote})

    run %(rm -rf "#{current}/app/assets")

    %x(rm -rf #{assets_path}/*)
  end
end

namespace :app do
  desc 'Copy configuration files'
  task :setup do
    %w[config/database.yml config/sphinx.yml].each do |path|
      from  = "#{deploy_to}/#{path}"
      to    = "#{current}/#{path}"

      run "if [ -f '#{to}' ]; then rm '#{to}'; fi; ln -s #{from} #{to}"
    end
  end
end

namespace :counter_cache do
  desc '[counter_cache] updates all counter cache'
  task :all do
    run "cd #{current} && bundle exec rake counter_cache:all"
  end
end
