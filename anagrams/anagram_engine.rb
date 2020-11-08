# More legacy code, yay
# Cannibalized legacy code, yay

require 'set'
class AnagramEngine
    # Lesa orð í class collection
    def initialize
        @words = File.open("./shared/ord.txt", "r").readlines.map { |v| v.chomp }
        @anagrams = []
        @alpha = " aábdðeéfghiíjklmnoópqrstuúvwxyýzþæöc".chars
    end

    # Fá orð til baka
    def get_words
        return @words
    end

    #Returns a dictionary only with words that
    #have every character found in trim
    #Trim can contain other characters
    #Example:
    #   Sauðárkrókur
    #   could and should return
    #   [Sauð, ár, krókur, ...(and many more such as rauður)]
    def trim_dictionary(dico, trim)
        returnee = []
        dico.each do |word|
            trimmer = trim.chars
            failed = false
            word.chars.each do |char|
                if trimmer.include?(char)
                    trimmer.slice!(trimmer.index(char))
                else
                    failed = true
                end
            end
            returnee.push(word) unless failed
        end
        return returnee
    end

    def anagram_helper(dico, remainder, gram, top)
        #If gram contains something and remainder contains nothing
        if !gram.empty?
            if remainder.empty?
                gram = gram.split(" ").sort
                @anagrams.push(gram) unless @anagrams.include?(gram)
                #puts "#{gram.join(' ')}"
            end
        end
        return if dico.empty?

        dico.each do |word|
            break if @words_tested.length > 1000 && @superoptimize && @anagrams.length != 0
            break if @words_tested.length > 50 && @superduperoptimize && @anagrams.length != 0
            @deepcounter = 0 if top
            @deepcounter += 1 if !top
            next if @words_tested.include?(word)
            break if @deepcounter > @limit && !(@anagrams.length < 10)
            @counter -= 1 if top
            puts "#{@counter} iterations remaining" if top && @counter % 200 == 0
            #Remove word from remainder
            temp = remainder.clone.chars
            temp_gram = gram.clone #dislocate reference
            word.chars.each do |c|
                temp.slice!(temp.index(c))
            end
            temp = temp.join("")
            #temp is now remainder with word removed

            temp_gram += word + " "
            new_dico = trim_dictionary(dico.clone, temp).shuffle!

            anagram_helper(new_dico, temp, temp_gram, false)
            @words_tested.push(word) if top
        end

    end

    def find_anagrams_for(sentence)
        sentence.downcase!
        sentence.chars.select{|v| @alpha.include?(v)}
        @anagrams = []
        @words_tested = []
        sentence = sentence.split(" ").join("")
        #sentence = sauðárkrókur
        working_dictionary = trim_dictionary(@words, sentence).shuffle!
        @counter = working_dictionary.length
        @deepcounter = 0
        @optimize = sentence.length >= 10
        @superoptimize = @counter > 400
        @superduperoptimize = sentence.length > 16
        @limit = 50
        @limit = 5 if @superoptimize
        
        puts "Optimizing: #{@optimize}"
        puts "Superoptimizing: #{@superoptimize}"
        puts "Superduperoptimizing: #{@superduperoptimize}"
        puts "Iterations: #{@counter}"

        anagram_helper(working_dictionary.clone, sentence.clone, "", true)

        return @anagrams
    end
end
