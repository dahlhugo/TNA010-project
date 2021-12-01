# Text parsing
include("preprocess.jl");



function findall(pattern,string::AbstractString)
    toReturn = UnitRange{Int64}[]
    s = 1
    while true
        range = findnext(pattern,string,s)
        if range === nothing
             break
        else
            push!(toReturn, range)
            s = first(range)+1
        end
    end
    return toReturn
end

dictionary, sentences = preprocess("data.txt")

#creation of term-frequency matrix
mat = zeros(Int64, length(dictionary), size(sentences)[1])

for x in 1:size(mat)[1]
    for y in 1:size(mat)[2]
        mat[x, y] = length(collect(eachmatch(Regex(dictionary[x]), sentences[y, 1])))
        
    end
end

#------------------
#Saliency score 
#------------------
#TODO: Make mat into sparse matrix


F = LinearAlgebra.svd(mat);

to_list = 3;

# print(string("Top ", to_list, " key sentences:", '\n'))
# for i in partialsortperm(Vector(F.V[:, 1]), 1:to_list)
#     print(sentences[i, 2] * '\n')
# end
# print(string("Top ", to_list, " key words:", '\n'))
# for i in partialsortperm(Vector(F.U[:, 1]), 1:to_list)
#     print(dictionary[i] * '\n')
# end

#------------------
#Rank-k approximation
#----------
k = 10
D = F.Vt[1:k, :]
B = LinearAlgebra.qr(D, Val(true))

C = transpose([1:1:size(B.P)[1];])*B.P 

Ck = C[1:k]

for i in Ck
    print(sentences[trunc(Int,i), 2]*"\n")
end