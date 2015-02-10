module Socials
  class Devise
    # Generate DEVISE install & Model
    def self.setup_devise
      puts 'Running `rails g devise:install`'.light_blue
      system 'rails g devise:install'

      puts 'Running `rails g devise User`'.light_green
      system 'rails g devise User'

      puts 'Running `rails g devise:views`'.light_green
      system 'rails g devise:views'

      puts 'Running `rake db:migrate` for the devise User created'.light_blue
      system 'rake db:recreate'
    end

    # Update the devise to load the OmNiAuth gem
    def self.update_devise_rb
      puts 'Running `rails g socials:devise` for the devise User created'.light_green
      system 'rails g socials:devise'
    end
  end
end