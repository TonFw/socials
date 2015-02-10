require 'colorize'
module Socials
  module Generators
    class DeviseGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc 'It automatically update devise files'
      def copy_initializer
        update_routes
        update_devise_rb
        update_devise_user
        update_application_rb
        add_oauth_partial_links
        update_application_controller
      end

      # Add the Devise+OAuth Routes
      def update_routes
        inject_into_file 'config/routes.rb', after: "devise_for :users" do <<-'RUBY'
, controllers: { omniauth_callbacks: "omniauth_callbacks" }
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

      # Add the HTML with the partial Social Logins
      def add_oauth_partial_links
        template "views/users/shared/_link.html.slim", "app/views/users/shared/_link.html.slim"
        puts 'Check your app/views/users/shared/_link.html.slim to custom the OAuth links'.colorize(:light_green)
      end

      # Update the DeviseUser to execute OAuth correctly
      def update_devise_user
        inject_into_file 'app/models/user.rb', after: ":validatable" do <<-'RUBY'
, :omniauthable
  validates_presence_of :email
  has_many :authorizations

  def self.new_with_session(params,session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"],without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def self.from_omniauth(auth, current_user)
    authorization = Authorization.where(:provider => auth.provider, :uid => auth.uid.to_s, :token => auth.credentials.token, :secret => auth.credentials.secret).first_or_initialize
    if authorization.user.blank?
      user = current_user.nil? ? User.where('email = ?', auth["info"]["email"]).first : current_user
      if user.blank?
       user = User.new
       user.password = Devise.friendly_token[0,10]
       user.name = auth.info.name
       user.email = auth.info.email
       auth.provider == "twitter" ?  user.save(:validate => false) :  user.save
     end
     authorization.username = auth.info.nickname
     authorization.user_id = user.id
     authorization.save
   end
   authorization.user
  end
          RUBY
        end
      end

      # Add Devise auth & validations to the Main top Controller
      def update_application_controller
        inject_into_file 'app/controllers/application_controller.rb', after: "protect_from_forgery with: :exception\n" do <<-'RUBY'
  before_action :authenticate_or_token

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:locale, :name, :username, :email, :password, :password_confirmation, :role, :remember_me) }
      devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password, :role) }
      I18n.locale = @current_user.locale || I18n.default_locale unless @current_user.nil?
    end

    # Validate user session if is not API call
    def authenticate_or_token
      authenticate_user! if params[:controller].index('api').nil? && request.fullpath != root_path
      @current_user = current_user if @current_user.nil?
    end

          RUBY
        end
      end
    end
  end
end