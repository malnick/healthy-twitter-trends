# Healthy Twitter Trends
Evetually, the server in /bin/server will run on Heroku and there will be integration between the server and the ruby app that ferries web forum info to the search arg in my app. 
For now, to run:

```bin/twitq start|stop -d #=> run a query for the 10 recent twitter posts with the hashtag #healthy```

```bin/twitq start|stop -s $your_query -d #=> run a query for the 10 recent twitter posts with your own search input```

```bin/server start|stop #=> run the sinatra server on localhost:8080```

TODO:

1. Override the number of twitter quaries (you can do this now in the lib/health/search.rb line 66).

2. Include web forum info that plugs into the search query and query number in the app. 
