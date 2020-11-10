require_relative './poem_generator.rb'
require 'json'

source = File.open('./shared/hugi_smasogur.txt').read
markov = MarkovChains::Generator.new(source, 2)

get '/poems/poem/?' do
    return JSON.unparse(generate_poem(markov, 7))
end

get '/poems/poem/:syllables/?' do
    syllables = params[:syllables].to_i
    if syllables < 4 || syllables > 20
        return 'Please choose a syllable count between 4 and 20'
    end
    return JSON.unparse(generate_poem(markov, syllables))
end