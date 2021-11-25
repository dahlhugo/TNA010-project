#takes file path and process the data within text file.
function preprocess(file_path) 

    #open files data.txt and stoplist.txt
    f = open(file_path, "r")
    s = open("./Stoplist.txt")

    #reads file, stores in string
    string_data = read(f, String)
    stop_words_string = read(s, String);

    #empty dictionary
    dictionary = Set()
    stop_words = String.(split(stop_words_string, '\n'));
    

    #character vector with punctuations
    punctuations = ['.', '!', '?']

    #splits string into vector of substrings on punctuations
    string_vec = String.(split(string_data, punctuations, keepempty = true))

    #removes numbers and symbols in strings  
    sentences = [string_vec string_vec];
    

    #removes leading and trailing white spaces
    
    for i in 1:size(string_vec)[1]
        string_vec[i] = replace(string_vec[i], r"[0-9]" => s"");
        string_vec[i]= replace(string_vec[i], ['\n', '"', '/', '+', '-', 
        '(', ')', '=', '[',']', '@', '|', '^'] => "");
        string_vec[i] = replace(string_vec[i], [',', ':'] => " ");
        string_vec[i] = String.(strip(string_vec[i], (' ')));
        
        #TODO: Remove stop_words
        temp = String.(split(string_vec[i], " "))
        for j in temp
            for k in stop_words
                if !(j == k)
                    string_vec[i] = replace(string_vec[i], k => "")
                    push!(dictionary, j)                              
                end
            end
        end
    end

    sentences[: , 1] = string_vec;
    sentences = sentences[(sentences[:, 1].!=""), :];

    #dictionary = dictionary[dictionary[:].!=""]

    #TODO: Implement stemming


    return dictionary;
end

sentences = preprocess("data.txt")

print(length(sentences))
