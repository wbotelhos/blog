require 'bundler/capistrano'

set :application, 'wbotelhos.com'

set :branch        , 'master'
set :deploy_via    , :remote_cache
set :keep_releases , 2
set :repository    , 'git@github.com:wbotelhos/wbotelhos-com.git'
set :scm           , :git

set :group  , 'ubuntu'
set :runner , 'ubuntu'
set :user   , 'ubuntu'

set :use_sudo, false

set :deploy_to , '/var/www/wbotelhos'
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
    assets.precompile
    app.setup
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
    %w[config/database.yml].each do |path|
      from = "#{deploy_to}/#{path}"
      to   = "#{current}/#{path}"

      run "if [ -f '#{to}' ]; then rm '#{to}'; fi; ln -s #{from} #{to}"
    end
  end
end
