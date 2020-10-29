require 'sinatra'
require 'sinatra/cors'
require 'json'

set :allow_origin, "http://kaffi.life http://kaffi.coffee"

before do
    content_type :json
end

get '/?' do
    return "Yea, I work out. What about you?"
end

get '/rhymes/?' do
    return ["Funky", "Junkie", "Spunky", "Spelunky", "Bunkie", "Hunkie", "Lunky", "Blunky", "Munky", "Runky"].to_json
end
