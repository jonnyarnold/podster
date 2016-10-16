# The PodcastStore stores a single
# Podcast.

require "mongo"
require "podster/credential"
require "podster/podcast"

MONGODB_URI = ENV["MONGODB_URI"] || "mongodb://127.0.0.1:27017/podster"
MONGODB_COLLECTION = ENV["MONGODB_COLLECTION"] || "podcasts"

ADMIN_USERNAME = ENV["ADMIN_USERNAME"] || "admin"
ADMIN_PASSWORD = ENV["ADMIN_PASSWORD"] || "password"

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
      Podcast.from_hash(@collection.find.first)
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

  end
end
