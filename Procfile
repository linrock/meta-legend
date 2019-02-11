web: bundle exec rails s
importer: bundle exec rails runner 'RepeatingTasks.new.import_replays'
stats: bundle exec rails runner 'RepeatingTasks.new.calculate_legend_stats'
cache: bundle exec rails runner 'RepeatingTasks.new.warm_json_response_caches'
webhooks: bundle exec rails runner 'WebhookBlobConverter.new.convert_slowly'
worker: bundle exec sidekiq
solr: solr start -f -h localhost -p 8983 -s solr
