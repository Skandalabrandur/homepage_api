require_relative './anagram_engine.rb'

get '/anagrams/:sentence/?' do
    engine = AnagramEngine.new
    h = Hash.new
    return JSON.unparse((engine).find_anagrams_for(params[:sentence].downcase)) if params[:sentence].length <= 30
    return JSON.unparse([["Setning of löng,", " mest 30 stafir"]]) if params[:sentence].length > 30
end