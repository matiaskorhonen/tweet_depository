How to Depploy to Heroku
========================

First time
----------

### Create the Heroku app

1. Clone the repository (if you haven't already)
2. `bundle install`
3. `heroku create my-awesome-tweets` (or whatever name you want to give the app)

### Register the app on Twitter

1. Go to <https://dev.twitter.com/apps>
2. Create a new app (read-only permissions are sufficient)
  * Set the callback URL as `http://my-awesome-tweets.herokuapp.com/auth/twitter/callback`
3. Keep the page open or copy the key and secret

### Configure the Heroku app

1. Set the Twitter API credentials (copy the values from the last section):
  * `heroku config:add TWITTER_KEY=foo TWITTER_SECRET=bar`
2. If you want your Depository to be publicly accessible, do:
  * `heroku config:add PUBLIC_TIMELINE=true`
3. `heroku addons:add memcache`
4. `heroku addons:add pgbackups:auto-month` *(optional)*
5. `git push heroku master`
6. `heroku run rake db:migrate`
7. Go to `http://my-awesome-tweets.herokuapp.com` and log in

### Do the initial Tweet import

This will import your latest 3200 tweets

  rake timeline:initial_import

### Set up the Heroku Scheduler

1. `heroku addons:add scheduler:standard`
2. `heroku addons:open scheduler`
3. Add a new **Hourly** job:
  * ` rake timeline:update`

*Note: this will only import your latest 200 tweets each hour, so don't tweet more than that :)*
