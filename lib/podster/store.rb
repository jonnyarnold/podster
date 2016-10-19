# The PodcastStore stores a single
# Podcast.

require "mongo"
require "podster/credential"
require "podster/podcast"

MONGODB_URI = ENV["MONGODB_URI"] || "mongodb://127.0.0.1:27017/podster"
MONGODB_COLLECTION = ENV["MONGODB_COLLECTION"] || "podcasts"

ADMIN_USERNAME = ENV["ADMIN_USERNAME"] || "admin"
ADMIN_PASSWORD = ENV["ADMIN_PASSWORD"] || "password"

PODCAST_SEED_FILE = "podcast.yml"

module Podster
  class Store

    def initialize
      @db = Mongo::Client.new(MONGODB_URI)
      @collection = @db[MONGODB_COLLECTION]
    end

    def credentials
      Credential.new(ADMIN_USERNAME, ADMIN_PASSWORD)
    end

    # Gets the podcast for this instance.
    def podcast
      # We only ever have one podcast.
      podcast_hash = @collection.find.first || seed!
      Podcast.from_hash(podcast_hash)
    end

    # Saves the podcast for this instance.
    def podcast=(p)
      # We only ever have one podcast.
      @collection.update_one({}, p.to_h, upsert: true)
    end

    def episode(id)
      podcast.episode(id)
    end

    def clear!
      @collection.delete_many
    end

    def seed!
      podcast_hash = Podster::Podcast.from_hash(YAML.load_file(PODCAST_SEED_FILE)).to_h
      @collection.update_one({}, podcast_hash, upsert: true)
      podcast_hash
    end
  end
end
