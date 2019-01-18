
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
    method = :post
    domain_url = url
    user_data = {lis_person_contact_email_primary: email, lis_person_contact_name_given: first_name,lis_person_contact_name_family: last_name, user_id: id.to_s}
    oauth_config = { consumer_key: oauth_consumer_key, consumer_secret: secret_key }
    # Usage
    oauth = OauthOne::Helper.new(method, domain_url, user_data, oauth_config)
    response = oauth.make_request


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
