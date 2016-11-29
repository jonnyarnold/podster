require "sinatra/base"
require "podster/episode"

module Podster
  class WebServer < Sinatra::Base

    get "/episode/new" do
      slim :"episode/new", layout: :head
    end

    post "/episode" do
      ensure_authorized!

      episode = Episode.from_hash(params, podcast: store.podcast)
      store.podcast = store.podcast.add_episode(episode)


      redirect to("/")
    end

    post "/episode/:id" do
      ensure_authorized!

      episode = Episode.from_hash(params, podcast: store.podcast)
      store.podcast = store.podcast.update_episode(episode)

      redirect to("/")
    end

    get "/episode/:id" do
      ensure_authorized!

      @episode = store.episode(params[:id]) || not_found
      slim :"episode/show", layout: :head
    end

    get "/episode/:id/delete" do
      ensure_authorized!

      store.podcast = store.podcast.delete_episode(params[:id])
      redirect to("/")
    end

  end
end