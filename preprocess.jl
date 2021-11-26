using Pkg
Pkg.instantiate()

#takes file path and process the data within text file.
using Snowball
import Base.findall

function preprocess(file_path) 

    #open files data.txt and stoplist.txt
    f = open(file_path, "r")
    s = open("./Stoplist.txt")

    #reads file, stores in string
    string_data = read(f, String)
    stop_words_string = read(s, String);

    #empty dictionary
    dictionary = Set()
    stop_words = String.(split(stop_words_string, "\r\n"));

    #character vector with punctuations
    punctuations = ['.', '!', '?']

    #splits string into vector of substrings on punctuations
    string_vec = String.(split(string_data, punctuations, keepempty = true))

    #removes numbers and symbols in strings  
    sentences = [string_vec string_vec];
    

    #removes leading and trailing white spaces
    stmr = Stemmer("english");
    for i in 1:size(string_vec)[1]
        string_vec[i] = replace(string_vec[i], r"[0-9]" => s"");
        string_vec[i]= replace(string_vec[i], ['"', '/', '\\', '+', '-', '~', 
        '(', ')', '=', '[',']', '@', '|', '^', '*', '{', '}', '%', '<', '>'] => "");
        string_vec[i] = replace(string_vec[i], ['\r', '\n', ',', ':'] => " ");
        string_vec[i] = String.(strip(string_vec[i], (' ')));
        string_vec[i] = stem_all(stmr, string_vec[i]);
        string_vec[i] = lowercase(string_vec[i])
        
        #TODO: Remove stop_words
        temp = String.(split(string_vec[i], " "))
        for j in temp
            if !(in(stop_words).(j))
                push!(dictionary, j)
                #print("added" * j * '\n')
            else
                string_vec[i] = replace(string_vec[i], j => "")
                #print(j * '\n')                     
            end
        end
    end

    sentences[: , 1] = string_vec;
    sentences = sentences[(sentences[:, 1].!=""), :];
    dictionary = filter(e->length(e) > 1, dictionary)
    dictionary = sort!(collect(dictionary))

    #dictionary = dictionary[dictionary[:].!=""]

    #TODO: Implement stemming


    return (dictionary, sentences);
end

function findall(pattern,string::AbstractString)
    toReturn = UnitRange{Int64}[]
    s = 1
    while true
        range = findnext(pattern,string,s)
        if range == nothing
             break
        else
            push!(toReturn, range)
            s = first(range)+1
        end
    end
    return toReturn
end

dictionary, sentences = preprocess("data.txt")

length(dictionary)
#print(dictionary)
size(sentences)

print(dictionary)
print(sentences[2, 1])

dictionary[301]

findall(dictionary[301], sentences[2, 1])

mat = zeros(Int64, size(sentences)[1], length(dictionary))

st = "Today is a fresh day: not too warm, not to cold, just fresh!"

a = findall("fresh", st)
print(length(a))
for x = size(mat)[1]
    for y = size(mat)[2]
        mat[x, y] = length(findall(dictionary[y],sentences[x, 1]))
    end
end


print(mat)


