require 'colorize'
module Socials
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)
      
      desc "It automatically create it SOCIALS initializer on the rails app"
      def copy_initializer
        update_files
        add_templates
      end

      # Add the files on the templates folder to the Rails App
      def add_templates
        # Add the config YML (social_credentials)
        template "config/social_keys.yml", "config/social_keys.yml"
        template "config/social_keys.yml", "config/social_keys.example.yml"
        puts 'Update your social_keys.yml with your social credentials & add it to your IGNORE & just keep the .example versioned'.colorize(:light_yellow)

        template 'tasks/socials.rake', 'lib/tasks/socials.rake'
        puts 'Just created the socials rake tasks, check it on the GitHub README'.colorize(:light_blue)

        template 'tasks/recreate.rake', 'lib/tasks/recreate.rake'
        puts 'Now you can easy rebase (clean up) your DB using rake db:recreate'.colorize(:light_green)

        # Add the OAuth Controller
        template "controllers/omniauth_callbacks_controller.rb", "app/controllers/omniauth_callbacks_controller.rb"
        puts 'Check out you your app/controllers/omniauth_callbacks_controller.rb which persist the social user through devise'.colorize(:light_green)
      end

      # Update files to let the Social working
      def update_files
        update_gemfile
      end

      # Add dependency GEMs & run the bundle install
      def update_gemfile
        inject_into_file 'Gemfile', after: "source 'https://rubygems.org'\n" do <<-'RUBY'
# Easier & faster then ERB
gem 'slim-rails', '~> 2.1.5'

# For easy user session management
gem 'devise', '~> 3.4.1'

# Gem to generate SocialShareURLs
gem 'just_share', '~> 1.0.4'

# Social network with PaymentMethod
gem 'rents', '~> 1.0.0'

# OAuth
gem 'koala', '~> 1.11.1'
gem 'omniauth', '~> 1.2.2'
gem 'omniauth-oauth2', '~> 1.2.0'
gem 'omniauth-facebook', '~> 2.0.0'
gem 'omniauth-github', '~> 1.1.2'
gem 'omniauth-google-oauth2', '~> 0.2.6'
gem 'omniauth-linkedin', '~> 0.2.0'
gem 'omniauth-twitter', '~> 1.1.0'

# Social
gem 'twitter', '~> 5.13.0'
gem 'linkedin', '~> 1.0.0'
          RUBY
        end

        puts 'Check out your Gemfile to know the GEMs which were added to run the Devise OAuth integration'.colorize(:light_green)
        puts 'Run `bundle install` & then run `rake socials:devise`'.red
      end
    end
  end
end