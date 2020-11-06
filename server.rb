require 'sinatra'
require 'sinatra/cors'
load './rhymes/server.rb'

set :allow_origin, "*"

before do
    content_type :json
end

get '/?' do
    return "Yea, I work out. What about you?"
end


