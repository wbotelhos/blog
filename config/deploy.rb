require "bundler/capistrano"

set :application, "ec2-177-71-153-95.sa-east-1.compute.amazonaws.com"

set :keep_releases, 3

default_run_options[:pty] = true
set :ssh_options, {:forward_agent => true}
set :use_sudo, false

set :scm, :git
set :repository, "git@github.com:wbotelhos/blog.git"
set :branch, "master"

set :user, "ubuntu"
set :runner, "ubuntu"
set :group, "ubuntu"
set :use_sudo, false

set :deploy_to, "/home/ubuntu/www/wbotelhos-br"
set :current, "#{deploy_to}/current"

role :web, application
role :app, application
role :db,  application, :primary => true

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:keys] = "/Users/wbotelhos/ubuntu.pem"

after :deploy, "deploy:cleanup"
after :deploy, "app:setup"
after :deploy, "sphinx:config"

namespace :deploy do
  task :start do
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
  desc "Copy configuration files"
  task :setup do
    %w[
      config/database.yml
      config/sphinx.yml
    ].each do |path|
      from = "#{deploy_to}/#{path}"
      to = "#{current}/#{path}"

      run "if [ -f '#{to}' ]; then rm '#{to}'; fi; ln -s #{from} #{to}"
    end
  end
end

namespace :sphinx do
  desc "Regenerate Sphinx configuration"
  task :config do
    run "cd #{current} && bundle exec rake ts:config"
  end

  desc "Rebuild index"
  task :rebuild do
    run "cd #{current} && bundle exec rake ts:reindex"
  end

  desc "Index pending delta"
  task :index do
    run "cd #{current} && bundle exec rake ts:index"
  end
end
