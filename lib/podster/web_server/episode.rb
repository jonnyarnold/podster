require "sinatra/base"
require "podster/episode"

module Podster
  class WebServer < Sinatra::Base

    get "/episode/new" do
      slim :"episode/new"
    end

    post "/episode" do
      ensure_authorized!

      episode = Episode.from_hash(params, podcast: store.podcast)
      store.podcast = store.podcast.add_episode(episode)


      redirect to("/episode/#{episode.id}")
    end

    get "/episode/:id" do
      ensure_authorized!

      @episode = store.episode(params[:id]) || not_found
      slim :"episode/show"
    end

  end
end