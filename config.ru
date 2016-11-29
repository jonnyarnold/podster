$LOAD_PATH.unshift File.expand_path('lib', File.dirname(__FILE__))
require "podster/web_server/web_server"
run Podster::WebServer
