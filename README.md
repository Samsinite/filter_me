filter_me
=========

[![Build Status](https://travis-ci.org/Samsinite/filter_me.png?branch=master)](https://travis-ci.org/Samsinite/filter_me) [![Code Climate](https://codeclimate.com/github/Samsinite/filter_me.png)](https://codeclimate.com/github/Samsinite/filter_me)

### A Rails/ActiveRecord filtering gem

FilterMe provids helpers and classes that provides filtering using Ruby classes and object oriented development

## Installation

``` ruby
gem "filter_me", "0.1.0"
```

## Filter:
\* Subject to change as the API moves closer to 1.0)

``` ruby
class AccountsFilter < FilterMe::ActiveRecordFilter
  model Account
    
  field :type, [:matches, :eq, :not_eq]
  field :cost, [:lt, :gt, :lteq, :gteq, :eq]
end
    
class AccountsController < ApplicationController
  include FilterMe
      
  def index
    @accounts = filter_me(Account.all)
  end
end
```

Given a controller that recieves params like the following:
``` ruby
params # => {filters: {type: {eq: "admin"} } }
```

The following SQL would be performed (Using ActiveRecord):
``` SQL
SELECT "accounts".* FROM "accounts" WHERE ("accounts"."type" = "admin")
```

## Nested Filtering:

``` ruby
class UsersFilter < FilterMe::ActiveRecordFilter
  model User
    
  association :account, :filter_class => AccountsFilter
  field :username, [:matches, :eq, :not_eq]
end
    
class UsersController < ApplicationController
  include FilterMe
      
  def index
    @users = filter_me(User.all)
  end
end
```

With the following params:
``` ruby
params # => {:filters => {
              :email => {:matches => "%test.com"},
              :account => {:cost => {:lt => 100000}}
            }}
```
Performs:
``` SQL
SELECT "users".* FROM "users" INNER JOIN "accounts" ON "accounts"."user_id" = "users"."id" WHERE ("users"."email" LIKE '%test.com') AND ("accounts"."cost" < 100000)
```

## License
Copyright (c) 2014, Filter Me is developed and maintained by Sam Clopton, and is released under the open MIT Licence.
