require "podster"

require "podster/store"

require "sinatra/base"
require "slim"
require "slim/include"
require "sass"

module Podster
  class WebServer < Sinatra::Base
    set :root, File.expand_path(File.dirname(__FILE__))
    set :views, settings.root

    # Set up the data store.
    @@store = Store.new
    helpers do
      def store
        @@store
      end
    end

    get "/style.css" do
      sass :style
    end

  end
end

require "podster/web_server/authorization_helpers"
require "podster/web_server/index/index"
require "podster/web_server/podcast/podcast"
require "podster/web_server/episode/episode"
