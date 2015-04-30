web bundle exec rackup config.ru -p $PORT 
web: bundle exec puma -w 3 -t 16:16 -p $PORT -e production
resque: env TERM_CHILD=1 RESQUE_TERM_TIMEOUT=7 bundle exec rake resque:work