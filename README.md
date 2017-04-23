# CurrencyExchange

Install it as a usual gem. Which mean you can clone the repo and rake install inside the repo folder, or any other way to install gems directly from repo.

To execute the application you need to run `currency_exchange` in terminal. Use `currency_exchange --help` for help. For the valid vork you need to set up configuration variables use the command `currency_exchange --conf_set key=value` where key is the configuration key and value is its value.

Please set up next next variables for valid work of the gem

* currency_layer_access_key
* twitter_consumer_key
* twitter_consumer_secret
* twitter_access_token
* twitter_access_token_secret
* email_from
* email_domain (optional)
* email_server_address
* email_password
* email_username
* email_smtp_port

To use the gem functionality please read the gem for details.
```
  currency_exchange --list
  currency_exchange --list --print twitter
  currency_exchange --list --print console,twitter
```

```
  currency_exchange --convert 1
  currency_exchange --convert 1 --source USD --target EUR,AUD
  currency_exchange --convert 1 --source USD --target EUR,AUD --date 2016-01-01
```

```
  exe/currency_exchange --highest
  exe/currency_exchange --highest --source USD
  exe/currency_exchange --highest --source USD --target EUR,AUD
```

```
  exe/currency_exchange --exchange
  exe/currency_exchange --exchange --source USD
  exe/currency_exchange --exchange --source USD --target EUR,AUD
  exe/currency_exchange --exchange --source USD --target EUR,AUD --date 2016-01-01
```

# Trouble shuting for gmail accounts:
http://stackoverflow.com/questions/33918448/ruby-sending-mail-via-gmail-smtp
