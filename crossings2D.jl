include("save_utils.jl")
include("fractal_percolation2D.jl")

"""
    crossing(P)

Tells if there is an up/down crossing in the percolation P, using sparse variables.

# Example
```julia-repl
julia> P
5×5 BitArray{2}:
 0  1  0  1  1
 1  1  0  0  0
 0  0  1  1  0
 1  1  1  0  1
 1  1  1  1  1
julia> crossing(P)
0
```
"""
function crossing(P::BitArray{2})::Integer
    n = size(P)[1]
    A = spzeros(Bool, n,n)
    A[1,:] = P[1,:]
    c = 1
    while !any(A[n,:]) && any(A)
        A = neighbors!(P, n, A)
        c+=1
    end
    if any(A[n,:])
        return c
    else
        return 0
    end
end
function neighbors!(P::BitArray{2}, n::Integer, A::SparseMatrixCSC{Bool,Int64})::SparseMatrixCSC{Bool,Int64}
    I,J,V = findnz(A)
    B = spzeros(Bool, n,n)
    for k in 1:length(V)
        i = I[k]
        j = J[k]
        P[i,j] = false
        if i>1 && P[i-1,j]
            B[i-1,j] = true
        end
        if i<n && P[i+1,j]
            B[i+1,j] = true
        end
        if j>1 && P[i,j-1]
            B[i,j-1] = true
        end
        if j<n && P[i,j+1]
            B[i,j+1] = true
        end
    end
    return B
end

"""
    crossingProbability(n,p,d, rep)

Calculates an approximate probability to have an up/down crossing 
in a depth d percolation of an n*n grid with probability p, using rep experiments.

# Examples
```julia-repl
julia> crossingProbability(2,0.8,8, 100)
0.0
julia> crossingProbability(2,0.85,8, 100)
0.02
julia> crossingProbability(2,0.9,8, 100)
0.82
julia> crossingProbability(2,0.95,8, 100)
0.97
```
"""
function crossingProbability(n::Integer,p::Real,d::Integer,rep::Integer)::Real
    acc = Threads.Atomic{Int64}(0)
    Threads.@threads for i in 1:rep
        if crossing(fractalPercolation2D(n,p,d))!=0
            Threads.atomic_add!(acc, 1)
        end
    end
    return acc[]/rep
end

"""
    crossingLength(n,p,d, rep)

Calculates an approximate length of an up/down crossing (when existing)
in a depth d percolation of an n*n grid with probability p, using rep experiments.

# Examples
```julia-repl
julia> crossingLength(2,0.8,8, 100)
NaN
julia> crossingLength(2,0.85,8, 100)
430.0
julia> crossingLength(2,0.9,8, 100)
323.25
julia> crossingLength(2,0.95,8, 100)
272.44
```
"""
function crossingLength(n::Integer,p::Real,d::Integer,rep::Integer)::Real
    nc = Threads.Atomic{Int64}(0)
    lc = Threads.Atomic{Int64}(0)
    Threads.@threads for i in 1:rep
        l = crossing(fractalPercolation2D(n,p,d))
        if l!=0
            Threads.atomic_add!(nc, 1)
            Threads.atomic_add!(lc, l)
        end
    end
    return lc[]/nc[]
end

"""
    crossingData(n,p,d, rep)

Calculates an approximate length of an up/down crossing (when existing)
in a depth d percolation of an n*n grid with probability p, using rep experiments.

# Examples
```julia-repl
julia> crossingData(2,0.80,8, 100)
(0, 0, 1094707)
julia> crossingData(2,0.85,8, 100)
(2842, 7, 1812129)
julia> crossingData(2,0.90,8, 100)
(26192, 82, 2811395)
julia> crossingData(2,0.95,8, 100)
(27316, 100, 4312045)
```
"""
function crossingData(n::Integer,p::Real,d::Integer,rep::Integer)::Tuple{Int64,Int64,Int64}
    nc = Threads.Atomic{Int64}(0)
    lc = Threads.Atomic{Int64}(0)
    sq = Threads.Atomic{Int64}(0)
    Threads.@threads for i in 1:rep
        P = fractalPercolation2D(n,p,d)
        s = sum(P)
        l = crossing(P)
        if l!=0
            Threads.atomic_add!(nc, 1)
            Threads.atomic_add!(lc, l)
        end
        Threads.atomic_add!(sq, s)
    end
    return (lc[], nc[], sq[])
end



function saveCrossingSmartData(n::Integer, d::Integer, rep::Integer, fileName::String)
    smartSaveCrossingData(crossingData, n,d, rep, fileName)
end

rep = 50000
file_name = "crossings_2D_"*string(rep)*".csv"
entitleFile(file_name, "rep,n,d,p,nc,lc,sq")

saveCrossingSmartData(2, 1, rep, file_name)
# saveCrossingSmartData(2, 2, rep, file_name)
# saveCrossingSmartData(2, 3, rep, file_name)
# saveCrossingSmartData(2, 4, rep, file_name)
# saveCrossingSmartData(2, 5, rep, file_name)
# saveCrossingSmartData(2, 6, rep, file_name)
# saveCrossingSmartData(2, 7, rep, file_name)
# saveCrossingSmartData(2, 8, rep, file_name)

# saveCrossingSmartData(3, 1, rep, file_name)
# saveCrossingSmartData(3, 2, rep, file_name)
# saveCrossingSmartData(3, 3, rep, file_name)
# saveCrossingSmartData(3, 4, rep, file_name)
# saveCrossingSmartData(3, 5, rep, file_name)

# saveCrossingSmartData(5, 1, rep, file_name)
# saveCrossingSmartData(5, 2, rep, file_name)
# saveCrossingSmartData(5, 3, rep, file_name)

# saveCrossingSmartData(7, 1, rep, file_name)
# saveCrossingSmartData(7, 2, rep, file_name)

# saveCrossingSmartData(11, 1, rep, file_name)
# saveCrossingSmartData(11, 2, rep, file_name)

# saveCrossingSmartData(13, 1, rep, file_name)
# saveCrossingSmartData(13, 2, rep, file_name)

# saveCrossingSmartData(17, 1, rep, file_name)
# saveCrossingSmartData(17, 2, rep, file_name)

# saveCrossingSmartData(25, 1, rep, file_name)
# saveCrossingSmartData(50, 1, rep, file_name)
# saveCrossingSmartData(75, 1, rep, file_name)
# saveCrossingSmartData(100, 1, rep, file_name)
# saveCrossingSmartData(125, 1, rep, file_name)
# saveCrossingSmartData(150, 1, rep, file_name)
# saveCrossingSmartData(175, 1, rep, file_name)
# saveCrossingSmartData(200, 1, rep, file_name)
