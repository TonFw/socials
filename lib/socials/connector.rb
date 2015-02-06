require 'cgi'

# ParentClass which have the attrs to create the links
class Socials::Connector
  # It constructor must be reused by it children
  def initialize(params={})
    # SetUp, dynamically, the attrs
    setup_attrs(params)
  end

  # Config the app for the connection
  def setup() end
  # Redirect the user to the SocialNetwork SignUp page
  def sign_up(sign_up_hash) end
  # Return a base user to sig in it out of it lib
  def get_base_user() end
  # Get the user Logged hash & accesses (OAuth)
  def get_current_user() end
  # Get the Multi logins from the user (Pages, in Facebook case)
  def get_user_admin_logins() end
  # Retrieve the user accepted permissions on the SocialNetwork
  def get_active_permission() end
  # Share in Facebook OR tweet on Twitter
  def send_msg(msg, link) end
  # The current user avatar link
  def get_user_avatar() end
  # Post on the social
  def post(message, link, img) end

  protected
    # SetUp all attrs
    def setup_attrs(params)
      # Dynamic part
      params.each do |key, value|
        next unless key.to_s.index('[]').nil?
        self.class.__send__(:attr_accessor, :"#{key}")
        self.__send__("#{key}=", value)
      end
    end
end