# Ordrin-Ruby

An unofficial [ordr.in](http://ordr.in/) ruby API wrapper around the Restaurants, Users, and Orders.

The official ruby library can be found [here](https://github.com/ordrin/api-ruby)

# Installation

```
gem install ordrin-ruby
```

# Supported Ruby Versions

* Ruby 1.9.3
* Ruby 2.0.0

# Usage

To simplify implementation and to support discrepencies in API responses (keys are different for certain API calls even if they are the same value), all of the model objects (Restaurant, User, Order, etc) forward method
calls to a `Hashie::Mash`, which wrap the response returned from the Ordr.in API endpoints. 

This means all method names map to the documented responses found in the [Official Ordr.in API Documentation](https://hackfood.ordr.in/docs)

Method parameters also map to the parameters found in the official documentation.

## Configuration

You'll need to register for Ordr.in developer credentials. In an initializer you can call `init`. It takes two arguments:

1. Your API Key (required)
2. Your environment, which defaults to `:test`. The other supported option is `:production`. The environment is used to specify which Ordr.in hostname.

```
OrdrIn::Config.init("your API key", :production)
```

## Restaurants

Restaurants can be found by specifying an address:

```
restaurants = OrdrIn::Restaurant.deliveries(date_time: "ASAP", address: "1 Main Street", 
                                            zip_code: 77840, city: "College Station")
```

If you know your restaurant's id, you can:

```
restaurant = OrdrIn::Restaurant.new(id: 147)
```

Once you have a restaurant, you can do fun things like get it's details:

```
details = restaurant.details
details.restaurant_id # => "147"
details.city          # => "College Station"
```

Or check if a restaurant delivers to you:

```
delivery_check = restaurant.delivery_check(date_time: "ASAP", address: "456 Carroll St",
                                           zip_code: 11215, city: "Brooklyn")
delivery_check.msg # => "This restaurant does not deliver to your requested address"
```

And calculate the delivery fee:

```
delivery_fee = restaurant.delivery_fee(subtotal: 20.42, tip: 5.05, date_time: "ASAP",
                                       address: "1 Main Street", zip_code: 77840, 
                                       city: "College Station")
delivery_fee.rid # => 147
delivery_fee.tax # => 2.01
```

## Users

Let's create a user's account:

```
user = OrdrIn::User.create_account(email: "austen.dev+ordrin2@gmail.com", password: password,
                                   first_name: "Nyan", last_name: "Cat")
user.msg        # => "user saved"
user.first_name # => "Nyan"
```

### Addresses

Once we have a user, we can update that user's addresses:

```
address_info = { 
                 nick: "Home",
                 addr: "456 Carroll Street",
                 city: "Brooklyn",
                 state: "NY",
                 zip: 11215,
                 phone: "808-123-4567"
               }

address = user.create_address(address_info)
address.city # => "Brooklyn"
```

And also retrieve addresses:

```
user.all_addresses # Returns an array of addresses
```

Or get a specific address by nickname:

```
address = user.address("Home")
address.city # => "Brooklyn"
```

If we don't like an address, we can delete them too:

```
user.remove_address("Home")
```

### Credit Cards

Credit cards follow the same interface as addresses. We can create one like this:

```
cc_params = {
              nick: "Primary Card",
              name: "Nyan Cat Black Card",
              number: "4242424242424242",
              cvc: 123,
              expiry_month: "02",
              expiry_year: "2042",
              type: "Visa",
              bill_addr: "456 Carroll St.",
              bill_city: "Brooklyn",
              bill_state: "NY",
              bill_zip: "11215",
              bill_phone: "808-123-4567"
            }
            
credit_card = user.create_credit_card(cc_params)
credit_card.name # => "Nyan Cat Black Card"
```

We can find all of our credit cards:

```
credit_cards = user.find_all_credit_cards # Returns an array of all your credit cards
```

We can also find credit cards by nickname:

```
credit_card = user.find_credit_card("Primary Card")
credit_card.name # => "Nyan Cat Black Card"
```

If we want to get rid of a credit card, we can delete it by nickname:

```
user.remove_credit_card("Primary Card")
```


## Orders

## Error Handling

# Contributing

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

Don't forget to run the tests with `rake`

# License

Copyright (c) 2013 Austen Ito

Ordrin-Ruby is released under the [MIT License][4]
