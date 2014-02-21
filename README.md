FilterMe
=========

[![Build Status](https://travis-ci.org/Samsinite/filter_me.png?branch=master)](https://travis-ci.org/Samsinite/filter_me) [![Code Climate](https://codeclimate.com/github/Samsinite/filter_me.png)](https://codeclimate.com/github/Samsinite/filter_me) [![Gem Version](https://badge.fury.io/rb/filter_me.png)](http://badge.fury.io/rb/filter_me)

### A Rails/ActiveRecord filtering gem

FilterMe provids helpers and classes that makes request filtering easy using Ruby classes and object oriented development.

## Installation
``` ruby
gem "filter_me", "0.1.2"
```

## Filter:
\* Highly subject to change as the API moves closer to 1.0
``` ruby
class AccountsFilter < FilterMe::ActiveRecordFilter
  model Account
  association :user

  field :cost, :all
  field :account_type, [:matches]
end
```

An example of `field :cost, [:lt]` above would mean that the following method could be called:
`Account.arel_table[:cost].lt(filter_value)`

Example Usage:
``` ruby
class AccountsController < ApplicationController
  include FilterMe

  def index
    @accounts = filter_me(Account.all)
    respond_to do |format|
      format.json { render json: @accounts }
    end
  end
end

```

Plain request:
http://0.0.0.0:3000/accounts.json
``` json
{"accounts":[
  {"id":1, "cost":100000, "account_type":"admin"},
  {"id":2, "cost":50000, "account_type":"paid"},
  {"id":3, "cost":10000, "account_type":"free"}
]}
```
Performs:
``` SQL
SELECT "accounts".* FROM "accounts"
```

Now with some filtering:
http://0.0.0.0:3000/accounts.json?filters%5Baccount_type%5D%5Bmatches%5D=paid, `$.param({filters: {account_type: {matches: "paid"}}})`
``` json
{"accounts":[
  {"id":2, "cost":50000, "account_type":"paid"}
]}
```
Performs:
``` SQL
SELECT "accounts".* FROM "accounts" WHERE ("accounts"."account_type" LIKE 'paid')
```

Brilliant!

## Nested Filtering:
``` ruby
class UsersFilter < FilterMe::ActiveRecordFilter
  model User
  association :account # Defaults to AccountsFilter, can override with :filter_class => SomeFilter

  field :username, [:matches, :eq, :not_eq]
  field :email, [:matches, :eq, :not_eq]
end
    
class UsersController < ApplicationController
  include FilterMe
      
  def index
    @users = filter_me(User.all)
    respond_to do |format|
      format.json { render json: @users }
    end
  end
end
```

Plain request:
http://0.0.0.0:3000/users.json
``` json
{"users":[
  {"id":1, "username":"test1", "email":"test2@test.com", "account": {
    "id":1, "cost":100000, "account_type":"admin"
  }},
  {"id":2, "username":"test2", "email":"test2@test.com", "account":{
    "id":2, "cost":50000, "account_type":"paid"
  }},
  {"id":3, "username":"test3", "email":"test3@spaz.com", "account":{
    "id":3, "cost":10000, "account_type":"free"
  }}
]}
```
Performs:
``` SQL
SELECT "users".* FROM "users"
```

Now with some nested filtering:
http://0.0.0.0:3000/users.json?filters%5Baccount%5D%5Bcost%5D%5Blt%5D=50000
``` json
{"users":[
  {"id":3, "username":"test3", "email":"test3@spaz.com", "account":{
    "id":3,"cost":10000, "account_type":"free"
  }}
]}
```
Performs:
``` SQL
SELECT "users".* FROM "users" INNER JOIN "accounts" ON "accounts"."user_id" = "users"."id"
    WHERE ("accounts"."cost" < 50000)
```

Need to provide some top secret super duper special filtering? Go ahead:
``` ruby
class UsersFilter < FilterMe::ActiveRecordFilter
  model User
  association :account

  field :username, [:matches, :eq, :not_eq]
  field :email, [:matches, :eq, :not_eq]

  def special_filter(relation, filters)
    relation.where(id: filters)
  end
end
```
http://0.0.0.0:3000/users.json?filters%5Baccount%5D%5Bcost%5D%5Bgteq%5D=50000&filters%5Bspecial_filter%5D%5B%5D=3&filters%5Bspecial_filter%5D%5B%5D=2 Now performs:
``` SQL
SELECT "users".* FROM "users" INNER JOIN "accounts" ON "accounts"."user_id" = "users"."id"
    WHERE ("accounts"."cost" >= 50000) AND "users"."id" IN (3, 2)
```

## License
Copyright (c) 2014, Filter Me is developed and maintained by Sam Clopton, and is released under the open MIT Licence.
