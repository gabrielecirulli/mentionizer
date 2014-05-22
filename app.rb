require 'sinatra/base'
require 'sinatra/jsonp'
require 'json'

require 'analyzer'

class App < Sinatra::Base
  configure do
    use Rack::Logger
    helpers Sinatra::Jsonp
  end

  post '/users' do
    begin
      users = Analyzer.new(params[:html]).users
      response['Access-Control-Allow-Origin'] = '*'
      jsonp(users.map(&:as_json))
    rescue => e
      jsonp(
        error: true,
        class_name: e.class.name,
        message: e.message
      )
    end
  end
end

