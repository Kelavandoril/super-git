#!/usr/bin/env ruby
require 'main'
require_relative 'git_wrapper'
require_relative 'login'

ARGV << 'help' if ARGV.empty?

Main do
  name :sgit

  option('f', 'force') do
    argument :optional
    description 'Forces the operation'
  end

  option('q', 'quiet') do
    argument :optional
    description 'Produces no output'
  end

  mode 'checkout develop' do
    option('u', 'update') do
      argument :optional
      description 'Fetches from origin upstream, and then hard-resets to those changes'
    end

    def run
      sgit = GitWrapper.new
      options = params.to_options
      sgit.checkout_develop(force: options['force'], update: options['update'], quiet: options['quiet'])
    end
  end

  mode 'login' do
    def run
      login_all
    end
  end

  def run
    if ARGV.empty?
      puts help
      exit 1
    end
  end
end