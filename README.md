
# OAuth-One

Easly make Oath1 requests to other services

## Installation

Add this line to your application's Gemfile:

    gem 'oauth-one', require: "oauth_one/helper"


And then execute:

    $ bundle

Or install it yourself as:

    $ gem install oauth-one

## Usage

    # Setup data
    method = :get
    domain_url = 'http://some.app.com/auth/'
    user_date = { uid: user_email + encrypted_password }
    oauth_config = { consumer_key: ENV['OAUTH_KEY'], consumer_secret: ENV['OAUTH_SECRET'] }

    # Usage
    oauth = Oauth::Helper.new(method, domain_url, user_data, oauth_config)

    # Returns
    oauth.signature_base # Returns the signature appended in the auth url
    oauth.full_url       # The proper url used for authentication


After that, all you need to do is to redirect the user to `oauth.full_url`.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
