require "sinatra/base"


module Podster
  class WebServer < Sinatra::Base

    get "/" do
      @podcast = @@store.podcast
      slim :'index/index', layout: :head
    end

  end
end