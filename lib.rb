$serhljodar = ['a', 'á', 'e', 'é', 'i', 'í', 'o', 'ó', 'u', 'ú', 'y', 'ý', 'æ', 'ö', 'E', 'Y', 'A', 'I', 'Í']

#Finds the index of the nth vowel from the back
#backwards_vowel_index
def bvi(word, n)
    p = 0
    word.reverse.chars.each.with_index do |c, i|
        p += 1 if $serhljodar.include?(c)
        return (word.length - i) - 1 if p == n
    end
    return -1
end

def count_syllables(word)
    count = 0
    sword = word.clone
    sword.gsub!('au', 'A')
    sword.gsub!('ei', 'I')
    sword.gsub!('ey', 'Y')
    sword.gsub!('é', 'je')
    sword.chars.each do |c|
        count += 1 if $serhljodar.include?(c)
    end
    return count
end

def rhyme_root(word, atkv)
    sword = word.clone
    sword.gsub!('au', 'A')
    sword.gsub!('ei', 'Y')
    sword.gsub!('ey', 'Y')
    #sword.gsub!('je', 'J')
    #sword.gsub!('é', 'J')
    
    # Is this fix?
    sword.gsub!('é', 'je')
    
    sword.gsub!('i', 'I')
    sword.gsub!('y', 'I')
    sword.gsub!('í', 'Í')
    sword.gsub!('ý', 'Í')
 
    fi = bvi(sword, atkv)
    return sword[fi..word.length] if fi != -1
end

def find_rhyme(word, atkv)
    worde = word.chomp.downcase
    root = rhyme_root(worde, atkv)
    results = []

    File.open("dictionary.txt", "r").each_line do |line|
        if rhyme_root(line.chomp, atkv) == root
            results.push(line)
        end
    end

    puts "Fann rímorð:"

    results.each do |res|
        puts "#{res}" if count_syllables(res) == atkv
    end

end

def create_data_instructions
    x = File.open("instructions.txt", "a")
    x.write("CREATE TABLE rhymes (
        word TEXT PRIMARY KEY,
        root_one TEXT,
        root_two TEXT,
        root_three TEXT,
        syllables INTEGER
    );")
    File.open("dictionary.txt", "r").each_line do |line|
        word = line.chomp.downcase
        syllables = count_syllables(word)
        root_one = rhyme_root(word, 1)
        root_two = rhyme_root(word, 2)
        root_three = rhyme_root(word, 3)

        if syllables > 0 then
            x.write("insert into rhymes values('#{word}', '#{root_one}', '#{root_two}', '#{root_three}', #{syllables});\n") if syllables != 0
        end
    end
    x.close
end

#create_data_instructions
#find_rhyme("haraldur", 3)
