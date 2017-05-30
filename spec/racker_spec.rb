require 'spec_helper'

APP = Rack::Builder.parse_file('config.ru').first

module Codebreaker
  RSpec.describe Racker do
    include Rack::Test::Methods

    def app
      APP
    end

    def session
      last_request.env['rack.session']
    end

    describe "404" do
      it '404' do
        get '/sdhdj'
        expect(last_response.status).to eq(404)
      end
    end

    describe "/ page" do
      before {get '/'}

      it 'successful response' do
        expect(last_response.status).to eq(200)
      end

      it 'shows index page' do
        expect(last_response.body).to include('Codebreaker!')
      end

      it 'creates new session' do
        expect(session).to include(:game)
      end

      it 'returns 302 response' do
        get '/play'
        expect(last_response.status).to eq(302)
      end
    end

    describe "/game page" do
      before {get '/game'}

      context 'shows game page' do
        it 'successful response' do
          expect(last_response.status).to eq(200)
        end

        it 'entered new name' do
          expect(last_response.body).to include('Name:')
        end
      end

      context "play game requests" do
        before {get '/play_game', code: '1111'}

        it 'returns 302 response' do
          expect(last_response.status).to eq(302)
        end

        it 'return code' do
          expect(session[:code]).to eq('1111')
        end
      end

      context "hint request" do
        before {get '/hints'}
        it 'shows hint' do
          expect(session[:hint]).to match(1..6)
        end
      end

      context "menu request" do
        it 'returns 302 response exit' do
          get '/exit'
          expect(last_response.status).to eq(302)
        end

        it 'returns 302 response save' do
          get '/save'
          expect(last_response.status).to eq(302)
        end

        it 'returns 302 response open' do
          get '/open'
          expect(last_response.status).to eq(302)
        end
      end
    end

    describe "/statistics page" do
      before {get '/statistics'}

      it 'successful response' do
        expect(last_response.status).to eq(200)
      end

      it 'shows statistics page' do
        expect(last_response.body).to include('Statistics!')
      end

      it 'returns 302 response' do
        get '/exit'
        expect(last_response.status).to eq(302)
      end
    end
  end
end