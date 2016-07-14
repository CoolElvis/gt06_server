# frozen_string_literal: true
# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'gt06_server'
set :repo_url, 'git@github.com:CoolElvis/gt06_server.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/ubuntu/gt06_server'

set :rbenv_ruby, '2.3.1'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('logs', 'pids')

# Default value for default_env is {}
# set :default_env, { path: "#{fetch(:rvm_path)}:$PATH" }

# set :bundle_bins, fetch(:bundle_bins, []).push(:sidekiq, :sidekiqctl, :thin, :rackup)
# set :rvm_map_bins, (fetch(:rvm_map_bins, []) + fetch(:bundle_bins, []))

set :keep_releases, 5

namespace :deploy do
end
