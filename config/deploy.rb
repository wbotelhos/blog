require 'bundler/capistrano'

set :application, 'wbotelhos.com.br'

set :scm, :git
set :repository, 'git@github.com:wbotelhos/wbotelhos-com-br.git'
set :branch, 'master'
set :deploy_via, :remote_cache

set :user, 'ubuntu'
set :runner, 'ubuntu'
set :group, 'ubuntu'
set :use_sudo, false

set :deploy_to, '/var/www/wbotelhos-br'
set :current, "#{deploy_to}/current"

role :web, application
role :app, application
role :db,  application, primary: true

default_run_options[:pty] = true

ssh_options[:forward_agent] = true
ssh_options[:keys] = '~/.ssh/blogbr.pem'

after :deploy, 'deploy:cleanup'
after :deploy, 'sphinx:rebuild'
after :deploy, 'counter_cache:all'

namespace :deploy do
  task :start do
    %w(config/database.yml config/sphinx.yml).each do |path|
      from  = "#{deploy_to}/#{path}"
      to    = "#{current}/#{path}"

      run "if [ -f '#{to}' ]; then rm '#{to}'; fi; ln -s #{from} #{to}"
    end

    run "cd #{current} && RAILS_ENV=production && GEM_HOME=/opt/local/ruby/gems && bundle exec unicorn_rails -c #{deploy_to}/config/unicorn.rb -D"
  end

  task :stop do
    run "if [ -f #{deploy_to}/shared/pids/unicorn.pid ]; then kill `cat #{deploy_to}/shared/pids/unicorn.pid`; fi"
  end

  task :restart do
    stop
    start
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

namespace :sphinx do
  desc '[ts:rebuild] stop, config, index and start'
  task :rebuild do
    run "cd #{current} && sudo bundle exec rake ts:rebuild"
  end
end

namespace :counter_cache do
  desc '[counter_cache] updates all counter cache'
  task :all do
    run "cd #{current} && bundle exec rake counter_cache:all"
  end
end
