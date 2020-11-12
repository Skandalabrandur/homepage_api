require_relative 'markov_chains/lib/markov_chains.rb'

load './poems/rhyme_lib.rb'

def collect_sentence(h, markov, syllables)
    sentence   = markov.get_sentences(1)[0]
    return if sentence.nil?
    last_word  = sentence.split(" ")[-1]
    collection = {
        :sentence =>sentence,
        :syllables=>count_syllables(sentence.downcase)
    }
    root = rhyme_root(last_word, count_syllables(last_word))

    if collection[:syllables] == syllables
        h[root] = h[root] + [collection]
    end
end

def different_endings?(hcollection)
    endings = []
    hcollection.each do |col|
        last = col[:sentence].split(" ")[-1].gsub(/[[:punct:]]/, "").downcase
        if !endings.include?(last)
            endings.push(last)
        end
    end
    
    return endings.length > 1
end

def generate_haiku(markov)
    haiku = []

    found = 0
    until found == 3
        sentence  = markov.get_sentences(1)[0]
        syllables = count_syllables(sentence.downcase)

        if found == 0 || found == 2
            if syllables == 5
                haiku.push(sentence)
                found += 1
            end
        elsif found == 1
            if syllables == 7
                haiku.push(sentence)
                found += 1
            end
        end
    end
    return haiku
end

def generate_poem(markov, syllables)
    h = Hash.new{[]}
    
    10000.times do
        collect_sentence(h, markov, syllables)
    end
    
    y = h.sort_by { |key, val| -val.length }
    y = y.select { |val| val[1].length > 2 }
    y = y.select { |val| different_endings?(val[1]) }
    
    endings = []
    poem = []
    y.shuffle!
    2.times do
        y[0][1].each do |v|
            ending = v[:sentence].split(" ")[-1].gsub(/[[:punct:]]/, "").downcase
            if !endings.include?(ending)
                poem.push(v[:sentence])
                endings.push(ending)
                break
            end
        end
        
        y[1][1].each do |v|
            ending = v[:sentence].split(" ")[-1].gsub(/[[:punct:]]/, "").downcase
            if !endings.include?(ending)
                poem.push(v[:sentence])
                endings.push(ending)
                break
            end
        end
    end
    return poem
end
