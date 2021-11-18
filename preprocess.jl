#takes file path and process the data within text file.
function preprocess(file_path) 

    #open file data.txt
    f = open(file_path, "r")

    #reads file, stores in string
    string_data = read(f, String)

    #character vector with punctuations
    punctuations = ['.', '!', '?']

    #removes numbers and symbols in strings
    string_data = replace(s, r"[0-9]" => s"")
    string_data = replace(s, ['\n', '"', '/', '+', '-', '(', ')', '=', '[',']'] => "")
    string_data = replace(s, [',', ':'] => " ")

    #splits string into vector of substrings on punctuations
    string_vec = String.(split(s, punctuations, keepempty = false))

    #removes leading and trailing white spaces
    for i in 1:size(string_vec)[1]
        string_vec[i] = String.(strip(string_vec[i], (' ')))
    end

    #removes empty strings in vector
    sentences = filter(!(isempty), string_vec)

    return sentences
end