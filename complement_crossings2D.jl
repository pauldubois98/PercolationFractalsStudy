include("save_utils.jl")
include("fractal_percolation2D.jl")

"""
    complementCrossing(P)

Tells if there is an up/down crossing in complement the percolation P, using sparse variables.

# Example
```julia-repl
julia> P = fractalPercolation2D(5,0.4,1)
5×5 BitArray{2}:
 0  0  1  0  1
 1  0  1  0  0
 0  1  1  0  0
 1  1  1  1  0
 0  0  0  0  0

julia> complementCrossing(P)
6
```
"""
function complementCrossing(P::BitArray{2})::Integer
    n = size(P)[1]
    A = spzeros(Bool, n,n)
    A[1,:] = 1 .- P[1,:]
    c = 1
    while !any(A[n,:]) && any(A)
        A = complementNeighbors!(P, n, A)
        c+=1
    end
    if any(A[n,:])
        return c
    else
        return 0
    end
end
function complementNeighbors!(P::BitArray{2}, n::Integer, A::SparseMatrixCSC{Bool,Int64})::SparseMatrixCSC{Bool,Int64}
    I,J,V = findnz(A)
    B = spzeros(Bool, n,n)
    for k in 1:length(V)
        i = I[k]
        j = J[k]
        P[i,j] = true
        if i>1 && !P[i-1,j]
            B[i-1,j] = true
        end
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
    complementCrossingProbability(n,p,d, rep)

Calculates an approximate probability to have an up/down crossing on the complement of
a depth d percolation of an n*n grid with probability p, using rep experiments.

# Examples
```julia-repl
julia> complementCrossingProbability(2,0.80,8, 100)
0.95
julia> complementCrossingProbability(2,0.85,8, 100)
0.54
julia> complementCrossingProbability(2,0.90,8, 100)
0.05
```
"""
function complementCrossingProbability(n::Integer,p::Real,d::Integer,rep::Integer)::Real
    acc = Threads.Atomic{Int64}(0)
    Threads.@threads for i in 1:rep
        if complementCrossing(fractalPercolation2D(n,p,d))!=0
            Threads.atomic_add!(acc, 1)
        end
    end
    return acc[]/rep
end

"""
    complementCrossingLength(n,p,d, rep)

Calculates an approximate length of an up/down complementCrossing (when existing)
in a depth d percolation of an n*n grid with probability p, using rep experiments.

# Examples
```julia-repl
julia> complementCrossingLength(2,0.95,8, 100)
NaN
julia> complementCrossingLength(2,0.85,8, 100)
282.5
julia> complementCrossingLength(2,0.75,8, 100)
258.81
```
"""
function complementCrossingLength(n::Integer,p::Real,d::Integer,rep::Integer)::Real
    nc = Threads.Atomic{Int64}(0)
    lc = Threads.Atomic{Int64}(0)
    Threads.@threads for i in 1:rep
        l = complementCrossing(fractalPercolation2D(n,p,d))
        if l!=0
            Threads.atomic_add!(nc, 1)
            Threads.atomic_add!(lc, l)
        end
    end
    return lc[]/nc[]
end

"""
    complementCrossingData(n,p,d, rep)

Calculates an approximate length of an up/down crossing (when existing) on the complement of
a depth d percolation of an n*n grid with probability p, using rep experiments.

# Examples
```julia-repl
julia> complementCrossingData(2,0.80,8, 100)
(26561, 98, 1133126)
julia> complementCrossingData(2,0.85,8, 100)
(13566, 49, 1718150)
julia> complementCrossingData(2,0.90,8, 100)
(1282, 5, 2937270)
julia> complementCrossingData(2,0.95,8, 100)
(0, 0, 4371481)
```
"""
function complementCrossingData(n::Integer,p::Real,d::Integer,rep::Integer)::Tuple{Int64,Int64,Int64}
    nc = Threads.Atomic{Int64}(0)
    lc = Threads.Atomic{Int64}(0)
    sq = Threads.Atomic{Int64}(0)
    Threads.@threads for i in 1:rep
        P = fractalPercolation2D(n,p,d)
        s = sum(P)
        l = complementCrossing(P)
        if l!=0
            Threads.atomic_add!(nc, 1)
            Threads.atomic_add!(lc, l)
        end
        Threads.atomic_add!(sq, s)
    end
    return (lc[], nc[], sq[])
end



function saveComplementCrossingSmartData(n::Integer, d::Integer, rep::Integer, fileName::String)
    smartSaveCrossingData(complementCrossingData, n,d, rep, fileName)
end

rep = 50000
file_name = "complement_crossings_2D_"*string(rep)*".csv"
entitleFile(file_name, "rep,n,d,p,nc,lc,sq")

# saveComplementCrossingSmartData(2, 1, rep, file_name)
# saveComplementCrossingSmartData(2, 2, rep, file_name)
# saveComplementCrossingSmartData(2, 3, rep, file_name)
# saveComplementCrossingSmartData(2, 4, rep, file_name)
# saveComplementCrossingSmartData(2, 5, rep, file_name)
# saveComplementCrossingSmartData(2, 6, rep, file_name)
# saveComplementCrossingSmartData(2, 7, rep, file_name)
# saveComplementCrossingSmartData(2, 8, rep, file_name)

# saveComplementCrossingSmartData(3, 1, rep, file_name)
# saveComplementCrossingSmartData(3, 2, rep, file_name)
# saveComplementCrossingSmartData(3, 3, rep, file_name)
# saveComplementCrossingSmartData(3, 4, rep, file_name)
# saveComplementCrossingSmartData(3, 5, rep, file_name)

# saveComplementCrossingSmartData(5, 1, rep, file_name)
# saveComplementCrossingSmartData(5, 2, rep, file_name)
# saveComplementCrossingSmartData(5, 3, rep, file_name)

# saveComplementCrossingSmartData(7, 1, rep, file_name)
# saveComplementCrossingSmartData(7, 2, rep, file_name)

# saveComplementCrossingSmartData(11, 1, rep, file_name)
# saveComplementCrossingSmartData(11, 2, rep, file_name)

# saveComplementCrossingSmartData(13, 1, rep, file_name)
# saveComplementCrossingSmartData(13, 2, rep, file_name)

# saveComplementCrossingSmartData(17, 1, rep, file_name)
# saveComplementCrossingSmartData(17, 2, rep, file_name)

# saveComplementCrossingSmartData(25, 1, rep, file_name)
# saveComplementCrossingSmartData(50, 1, rep, file_name)
# saveComplementCrossingSmartData(75, 1, rep, file_name)
# saveComplementCrossingSmartData(100, 1, rep, file_name)
# saveComplementCrossingSmartData(125, 1, rep, file_name)
# saveComplementCrossingSmartData(150, 1, rep, file_name)
# saveComplementCrossingSmartData(175, 1, rep, file_name)
# saveComplementCrossingSmartData(200, 1, rep, file_name)
