require 'colorize'
module Socials
  module Generators
    class DeviseGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc 'It automatically update devise files'
      def copy_initializer
        update_routes
        update_devise_rb
        update_application_rb
      end

      # Add the Devise+OAuth Routes
      def update_routes
        inject_into_file 'config/routes.rb', after: "application.routes.draw do\n" do <<-'RUBY'
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
          RUBY
        end

        puts 'Check out your config/routes.rb where the devise OAuth route was created'.colorize(:light_green)
      end

      # Update the application.rb to load the socials_keys on initialize
      def update_application_rb
        inject_into_file 'config/application.rb', after: "class Application < Rails::Application\n" do <<-'RUBY'

    # It setup your social apps
    social_keys = File.join(Rails.root, 'config', 'social_keys.yml')
    CONFIG = HashWithIndifferentAccess.new(YAML::load(IO.read(social_keys)))[Rails.env]

    unless CONFIG.nil?
      CONFIG.each do |k,v|
        ENV[k.upcase] ||= v
      end
    end

          RUBY
        end

        puts 'Just updated your config/initializers/application.rb to config the environment'.colorize(:light_blue)
      end

      # Add the ENV KEYs based on the social_keys.YML
      def update_devise_rb
        inject_into_file 'config/initializers/devise.rb', after: "config.sign_out_via = :delete\n" do <<-'RUBY'

  # Config Social Keys to create the SignUps
  config.sign_out_via = :get
  config.omniauth :facebook, ENV["FACEBOOK_KEY"], ENV["FACEBOOK_SECRET"], { :scope => 'email, offline_access', :client_options => {:ssl => {:ca_file => '/usr/lib/ssl/certs/ca-certificates.crt'}}}
  config.omniauth :twitter, ENV["TWITTER_KEY"], ENV["TWITTER_SECRET"], { :scope => 'r_fullprofile, r_emailaddress', :client_options => {:ssl => {:ca_file => '/usr/lib/ssl/certs/ca-certificates.crt'}}}
  config.omniauth :linkedin, ENV["LINKEDIN_KEY"], ENV["LINKEDIN_SECRET"], { :scope => 'r_fullprofile r_emailaddress', :client_options => {:ssl => {:ca_file => '/usr/lib/ssl/certs/ca-certificates.crt'}}}
  config.omniauth :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], scope: "user, public_repo"
  config.omniauth :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'], {}

        RUBY
        end

        puts 'Check your config/initializers/devise.rb which was updated to have the Social Keys used (OmniAuth linked to devise)'.colorize(:light_green)
        puts 'UPDATE your config/initializers/devise.rb if you need more data from the user, CHANGING the: SCOPE'.colorize(:light_yellow)
      end
    end
  end
end