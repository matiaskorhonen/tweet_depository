tweet_depository
================

Automatically archive your tweets

Development
-----------

1. Run `bundle install`

2. You need to create a new application on Twitter (<https://dev.twitter.com/apps>) to get a consumer key and secret for Twitter.
Define the callback URL as: `http://depository.rails.fi:3000/auth/twitter/callback`

3. You should create a `.env` file (in the project root) with the following contents:

```
PORT=3000
RACK_ENV=development
TWITTER_KEY="YOUR_KEY"
TWITTER_SECRET="YOUR_SECRET"
```

Once this is done, run: `foreman start`, and open <http://depository.rails.fi:3000/>
