# Kekeewin

API wrapper for Kekeewin on Scouting.io.

```
Such things as are generally understood by the tribe.
```

## Installation

Add to your Gemfile and run the `bundle` command to install it.

 ```ruby
 gem "kekeewin"
 ```

**Requires Ruby 1.9.2 or later.**


## Usage

Once configured with host, username, and password from Scouting.io, you can call any of the resources through the API.

 ```ruby
	Kekeewin::RestAPI.configure do |config|
	  config.host = "http://api.scouting.io"
	  config.username = "45w45gwe4w4w56"
	  config.password = "g4e56e456h56e5ht6"
	end

	Kekeewin::RestAPI.lodges
	Kekeewin::RestAPI.councils
 ```


## Development

Questions or problems? Please post them on the [issue tracker](https://github.com/scoutingio/kekeewin-gem/issues). You can contribute changes by forking the project and submitting a pull request. You can ensure the tests passing by running `bundle` and `rake`.

This gem is created by Scouting.io and is under the MIT License.