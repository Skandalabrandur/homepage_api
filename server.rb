require 'sinatra'

get '/?' do
    return "Yea, I work out. What about you?"
end

get '/marko/?' do
    return "Polo! " * Random.rand(1..10)
end
