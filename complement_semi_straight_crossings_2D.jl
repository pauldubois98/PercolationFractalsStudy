include("save_utils.jl")
include("fractal_percolation2D.jl")

"""
    semiStraightComplementCrossing2D(P)

Tells if there is an up/down crossing in the complement of the percolation P, using sparse variables.

# Example
```julia-repl
julia> P
5×5 BitArray{2}:
 0  1  0  1  1
 1  1  0  0  0
 0  0  1  1  0
 1  1  1  0  1
 1  1  1  1  1
julia> semiStraightComplementCrossing2D(P)
0
```
"""
function semiStraightComplementCrossing2D(P::BitArray{2})::Integer
    n = size(P)[1]
    A = spzeros(Bool, n,n)
    A[1,:] = P[1,:].==0
    c = 1
    while !any(A[n,:]) && any(A)
        A = complementSemiNeighbors!(P, n, A)
        c+=1
    end
    if any(A[n,:])
        return c
    else
        return 0
    end
end
function complementSemiNeighbors!(P::BitArray{2}, n::Integer, A::SparseMatrixCSC{Bool,Int64})::SparseMatrixCSC{Bool,Int64}
    I,J,V = findnz(A)
    B = spzeros(Bool, n,n)
    for k in 1:length(V)
        i = I[k]
        j = J[k]
        P[i,j] = true
        ### no back step
        # if i>1 && P[i-1,j]
        #     B[i-1,j] = true
        # end
        if i<n && !P[i+1,j]
            B[i+1,j] = true
        end
        if j>1 && !P[i,j-1]
            B[i,j-1] = true
        end
        if j<n && !P[i,j+1]
            B[i,j+1] = true
        end
    end
    return B
end



"""
    semiStraightComplementCrossingData2D(n,p,d, rep)

Calculates an approximate length of an up/down crossing (when existing) in the complement of 
a depth d percolation of an n*n grid with probability p, using rep experiments.

# Examples
```julia-repl
julia> semiStraightComplementCrossingData2D(2,0.85,8, 100)
(2, 1814570)
julia> semiStraightComplementCrossingData2D(2,0.90,8, 100)
(77, 2820724)
julia> semiStraightComplementCrossingData2D(2,0.95,8, 100)
(97, 4399902)
```
"""
function semiStraightComplementCrossingData2D(n::Integer,p::Real,d::Integer,rep::Integer)::Tuple{Int64,Int64,Int64}
    nc = Threads.Atomic{Int64}(0)
    lc = Threads.Atomic{Int64}(0)
    sq = Threads.Atomic{Int64}(0)
    Threads.@threads for i in 1:rep
        P = fractalPercolation2D(n,p,d)
        s = sum(P)
        l = semiStraightComplementCrossing2D(P)
        if l!=0
            Threads.atomic_add!(nc, 1)
            Threads.atomic_add!(lc, l)
        end
        Threads.atomic_add!(sq, s)
    end
    return (lc[], nc[], sq[])
end



function saveSemiStraightComplementCrossingSmartData(n::Integer, d::Integer, rep::Integer, fileName::String)
    smartSaveCrossingData(semiStraightComplementCrossingData2D, n,d, rep, fileName)
end


rep = 50000
file_name = "complement_crossings_semi_straight_2D_"*string(rep)*".csv"
entitleFile(file_name, "rep,n,d,p,nc,lc,sq")

# saveSemiStraightComplementCrossingSmartData(2, 1, rep, file_name)
# saveSemiStraightComplementCrossingSmartData(2, 2, rep, file_name)
# saveSemiStraightComplementCrossingSmartData(2, 3, rep, file_name)
# saveSemiStraightComplementCrossingSmartData(2, 4, rep, file_name)
# saveSemiStraightComplementCrossingSmartData(2, 5, rep, file_name)
# saveSemiStraightComplementCrossingSmartData(2, 6, rep, file_name)
# saveSemiStraightComplementCrossingSmartData(2, 7, rep, file_name)
# saveSemiStraightComplementCrossingSmartData(2, 8, rep, file_name)

# saveSemiStraightComplementCrossingSmartData(3, 1, rep, file_name)
# saveSemiStraightComplementCrossingSmartData(3, 2, rep, file_name)
# saveSemiStraightComplementCrossingSmartData(3, 3, rep, file_name)
# saveSemiStraightComplementCrossingSmartData(3, 4, rep, file_name)
# saveSemiStraightComplementCrossingSmartData(3, 5, rep, file_name)

# saveSemiStraightComplementCrossingSmartData(5, 1, rep, file_name)
# saveSemiStraightComplementCrossingSmartData(5, 2, rep, file_name)
# saveSemiStraightComplementCrossingSmartData(5, 3, rep, file_name)

# saveSemiStraightComplementCrossingSmartData(7, 1, rep, file_name)
# saveSemiStraightComplementCrossingSmartData(7, 2, rep, file_name)

# saveSemiStraightComplementCrossingSmartData(11, 1, rep, file_name)
# saveSemiStraightComplementCrossingSmartData(11, 2, rep, file_name)

# saveSemiStraightComplementCrossingSmartData(13, 1, rep, file_name)
# saveSemiStraightComplementCrossingSmartData(13, 2, rep, file_name)

# saveSemiStraightComplementCrossingSmartData(17, 1, rep, file_name)
# saveSemiStraightComplementCrossingSmartData(17, 2, rep, file_name)

# saveSemiStraightComplementCrossingSmartData(25, 1, rep, file_name)
# saveSemiStraightComplementCrossingSmartData(50, 1, rep, file_name)
# saveSemiStraightComplementCrossingSmartData(75, 1, rep, file_name)
# saveSemiStraightComplementCrossingSmartData(100, 1, rep, file_name)
# saveSemiStraightComplementCrossingSmartData(125, 1, rep, file_name)
# saveSemiStraightComplementCrossingSmartData(150, 1, rep, file_name)
# saveSemiStraightComplementCrossingSmartData(175, 1, rep, file_name)
# saveSemiStraightComplementCrossingSmartData(200, 1, rep, file_name)
