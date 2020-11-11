require 'sinatra'
require 'sinatra/cors'
load './rhymes/server.rb'
load './anagrams/server.rb'
load './poems/server.rb'

set :allow_origin, "*"
set :environment, :production

before do
    content_type :json
end

get '/?' do
    return 'kurte.is API'
end


