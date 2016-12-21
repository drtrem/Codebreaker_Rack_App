require 'erb'
require './lib/codebreaker'

class Racker
  include Codebreaker

  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
    @game = game
  end

  def response
    case @request.path
    when '/' then Rack::Response.new(render('index.html.erb'))
    when '/game' then Rack::Response.new(render('game.html.erb'))
    when '/play' then play
    when '/play_game' then play_game
    when '/hints' then hints
    when '/exit' then exit
    when '/save' then save
    when '/open' then open
    when '/statistics' then Rack::Response.new(render('statistics.html.erb'))
    else Rack::Response.new('Not Found', 404)
    end
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def play
    @request.session[:name] = @request.params['name']
    redirect_to('/game')
  end

  def play_game
    @request.session[:code] = @request.params['code']
    @request.session[:plus] = @game.guess(@request.params['code'])
    redirect_to('/game')
  end

  def hints
    @request.session[:hint] = @game.hint
    redirect_to('/game')
  end

  def exit
    @request.session.clear
    redirect_to('/')
  end

  def save
    File.open('./statistics.txt', 'a') do |f|
      f.puts 'Name: ', @request.session[:name], @game.statistik, Time.now, '<br>'
      f.puts "------------------------------<br>"
    end
    redirect_to('/game')
  end

  def open
    redirect_to('/statistics')
  end

  def game
    @request.session[:game] ||= Game.new
  end

  def data_session(data)
    @request.session[data]
  end

  def redirect_to(path)
    Rack::Response.new do |response|
      response.redirect(path)
    end
  end
end