require './lib/racker'
use Rack::Reloader
use Rack::Static, :urls => ['/stylesheets'], :root => 'public'
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: '46235647'

run Racker