require 'sinatra'

get '/' do
    return "Yea, I work out. What about you?"
end

get '/echo' do
    return "ECHO!"
end
