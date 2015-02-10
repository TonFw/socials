# Socials

## Installation

First install the Rails :gem:

    $ gem install 'rails'

Create your new Rails app:

    $ rails new app_name 

Install the Socials :gem:

    $ gem install 'socials'

Add it to you Gemfile (or it won't be able to call the g install)

  ```ruby
    gem 'socials', '~> 1.0.1'
  ```

Run the social generator:

    $ rails g socials:install

It updates your Gemfile :page_facing_up: so run the bundle

    $ bundle install

Now just let's link the Devise with the OAuth :boom:

    $ rake socials:devise

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment. 

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/socials/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
