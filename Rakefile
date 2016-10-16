$LOAD_PATH.unshift File.expand_path('lib', File.dirname(__FILE__))
require "rspec/core/rake_task"
require "podster"

RSpec::Core::RakeTask.new(:spec)

task :init_db do
  require "podster/store"
  require "podster/podcast"

  # Clear the store
  store = Podster::Store.new
  store.clear!

  # Add the default podcast document
  podcast = Podster::Podcast.from_hash(YAML.load_file("podcast.yml"))
  store.podcast = podcast
end

task :default => :spec
