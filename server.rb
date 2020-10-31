require 'sinatra'
require 'sinatra/cors'
require 'sqlite3'
require 'json'
require './lib'

set :allow_origin, "*"

$alpha  = ("a".."z").to_a + ["á", "é", "í", "ó", "ú", "æ", "ö", "þ", "ð", "ý"]
db = SQLite3::Database.open "rhymes.db"

def sanitize_alpha(input_word)
    input_word.chars.each do |c|
        input_word.delete!(c) unless $alpha.include?(c)
    end
    return input_word
end

before do
    content_type :json
end

get '/?' do
    return "Yea, I work out. What about you?"
end

################################################################################
# RHYMES START
# Rhymes is legacy code that I had to do minimal effort to get working
# I might consider optimizing this in the future but it works fast enough tbh
################################################################################
get '/rhymes/?' do
	content_type :json
	return "Engar niðurstöður".to_json
end

get '/rhymes/:word/?' do
    content_type :json

    word = params[:word].to_s.dup
    #syllables = params[:syllables].to_s.dup

    word = sanitize_alpha(word.downcase)

    howm = count_syllables(word)

    if howm == 0 then
	return "Engar niðurstöður".to_json
    end

    root = ""
    rootfield = ""
    if howm == 1 then
        root = rhyme_root(word, 1)
        rootfield = "root_one"
    elsif howm == 2 then
        root = rhyme_root(word, 2)
        rootfield = "root_two"
    elsif howm >= 3 then
        root = rhyme_root(word, 3)
        rootfield = "root_three"
    end

    stm = db.prepare "SELECT * FROM rhymes where #{rootfield} = '#{root}' and (syllables = #{howm} or syllables = 2 or syllables = 3)"
    rs = stm.execute


    words = Hash.new { Array.new }

    rs.each do |row|
        words[row[4]] += [row[0]] unless row[0] == word
    end

    if howm >= 3 && words.empty? 
        root = rhyme_root(word, 2)
        stm = db.prepare "SELECT * FROM rhymes where root_two = '#{root}' and (syllables = 2 or syllables = 3 or syllables = #{howm})"

        rs = stm.execute

        rs.each do |row|
            words[row[4]] += [row[0]] unless row[0] == word
        end

        words["Hálfrím"] = true unless words.empty?
    end

    if howm == 2 && words.empty?
        root = rhyme_root(word, 1)
        stm = db.prepare "SELECT * FROM rhymes where root_one = '#{root}' and (syllables = 2 or syllables = 3 or syllables = 1)"

        rs = stm.execute

        rs.each do |row|
            words[row[4]] += [row[0]] unless row[0] == word
        end

        words["Hálfrím"] = true unless words.empty?

    end

    unless words.empty?
        words.to_json
    else
        "Engar niðurstöður".to_json
    end

end
################################################################################
# RHYMES END
################################################################################