require 'socials'
require 'colorize'

namespace :socials do
  desc 'Automate socials'
  task devise: :environment do
    # Create the Devise user & set it up
    Socials::Devise.setup_devise
    Socials::Devise.update_devise_rb
  end
end