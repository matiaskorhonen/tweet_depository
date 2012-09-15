tweet_depository
================

Automatically archive your tweets

Development
-----------

1. Run `bundle install`

2. You need to create a new application on Twitter (<https://dev.twitter.com/apps>) to get a consumer key and secret for Twitter.
Define the callback URL as: `http://depository.rails.fi:3000/auth/twitter/callback`

4. Run `cp config/database.example.yml config/database.yml`

3. Run `rake db:setup`

4. You should create a `.env` file (in the project root) with the following contents:

```
PORT=3000
RACK_ENV=development
TWITTER_KEY="YOUR_KEY"
TWITTER_SECRET="YOUR_SECRET"
PUBLIC_TIMELINE=true
```

Once this is done, run: `foreman start`, and open <http://depository.rails.fi:3000/>

The `PUBLIC_TIMELINE` variable controls whether your depository is visible to the world.

Rails Console
-------------

You should use `foreman run rails c` to start the console session so that the Twitter API keys get set.

Rake Tasks
----------

After you have signed into the depository via the web interface, you can use the following rake task to do the initial import of Tweets:

```
rake timeline:initial_import
```

To update the timeline, you can run:

```
rake timeline:update
```

*NB. The update task will only import your 200 latest tweets, and so it is important that it is run regularly. On Herouk you should use the [Scheduler addon](https://addons.heroku.com/scheduler).*

If you're running the tasks locally, you should probably prefix them with `foreman run`
