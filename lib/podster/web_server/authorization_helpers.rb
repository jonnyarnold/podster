require "sinatra/base"

module Podster
  class WebServer < Sinatra::Base

    helpers do

      def ensure_authorized!
        return if authorized?
        headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
        halt 401, "Not authorized\n"
      end

      def authorized?
        @auth ||=  Rack::Auth::Basic::Request.new(request.env)
        @auth.provided? and @auth.basic? and @auth.credentials and @@store.credentials.match?(*@auth.credentials)
      end

    end
  end
end