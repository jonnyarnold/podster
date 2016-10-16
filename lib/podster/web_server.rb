require "podster"

require "podster/store"

require "sinatra/base"
require "slim"

module Podster
  class WebServer < Sinatra::Base
    set :root, File.expand_path('web_server', File.dirname(__FILE__))
    set :views, settings.root

    # Set up the data store.
    @@store = Store.new
    helpers do
      def store
        @@store
      end
    end

    get "/" do
      slim :index
    end

  end
end

require "podster/web_server/authorization_helpers"
require "podster/web_server/podcast"
require "podster/web_server/episode"
