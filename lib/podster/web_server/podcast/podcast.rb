require "sinatra/base"


module Podster
  class WebServer < Sinatra::Base

    get "/podcast.rss" do
      content_type "application/rss+xml"
      store.podcast.to_xml
    end

  end
end