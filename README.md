# Epersonate Gem

> [Official Ruby Wrapper](https://rubygems.org/gems/epersonate) for EPersonate API.

## EPersonate Documentation

[Official EPersonate Documentation](https://docs.epersonate.com)

## Installation

```bash
gem install epersonate
```

### Usage

```ruby
require 'epersonate'
```

### Using Personal Access Token

Go to https://epersonate.com/app/settings > Personal Access Token > Create Personal Access Token

Add this token to your environment variables.
 
```ruby
epersonate = Epersonate.new(EPERSONATE_TOKEN)
```

**Note: Replace `EPERSONATE_TOKEN` with the token generated before.**

## Example Usage

In a classic Rails application with a `sessions_controller.rb`

```ruby
class SessionsController < ApplicationController

    def login
        (...)
        current_user(user)
    end

    def current_user=(user)
        @current_user = user
    end

    def current_user
        if (@current_user)
            return @current_user
        end

        impersonation = epersonate.verify({request: request})

        if (impersonation["valid"])
            @current_user = User.find(impersonation["userId"].to_i)
        else
            remember_token = User.hexdigest(cookies[:remember_token])
            @current_user ||= User.find_by(remember_token: remember_token)
        end
    end
end
```


## Deploy

 - Update version in epersonate.gemspec

```bash
gem build epersonate.gemspec
gem push epersonate.x.x.x.gem
```