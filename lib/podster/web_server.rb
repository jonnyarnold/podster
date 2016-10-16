require "sinatra/base"

module Podster
  class WebServer < Sinatra::Base

    get "/" do
      "Hello, world!"
    end

  end
end