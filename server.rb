require 'sinatra'
require 'sinatra/cors'
load './rhymes/server.rb'
load './anagrams/server.rb'

set :allow_origin, "*"

before do
    content_type :json
end

get '/?' do
    return "kurte.is API"
end


