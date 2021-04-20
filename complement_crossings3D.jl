include("save_utils.jl")
include("fractal_percolation3D.jl")

"""
    complementCrossing(P)

Tells if there is an up/down crossing in the complement of the percolation P, using sparse variables.

# Example
```julia-repl
julia> P = fractalPercolation3D(2,0.4,1)
2×2×2 BitArray{3}:
[:, :, 1] =
 1  0
 1  0

[:, :, 2] =
 0  1
 0  0

julia> complementCrossing(P)
2

julia> P = fractalPercolation3D(2,0.4,1)
2×2×2 BitArray{3}:
[:, :, 1] =
 0  1
 1  1

[:, :, 2] =
 1  0
 0  1

julia> complementCrossing(P)
0
```
"""
function complementCrossing(P::BitArray{3})::Integer
    n = size(P)[1]
    x = Int32[]
    y = Int32[]
    z = Int32[]
    for i in 1:n
        for j in 1:n
            if !P[i,j,1]
                push!(x, i)
                push!(y, j)
                push!(z, 1)
            end
        end
    end
    c = 1
    while !(n in z) && length(x)>0
        x,y,z = complementNeighbors!(P, n, x,y,z)
        c+=1
    end
    if any(n in z)
        return c
    else
        return 0
    end
end
function complementNeighbors!(P::BitArray{3}, n::Integer, x::Array{<:Integer,1}, y::Array{<:Integer,1}, z::Array{<:Integer,1})
    new_x = Int32[]
    new_y = Int32[]
    new_z = Int32[]
    for i in 1:length(x)
        a = x[i]
        b = y[i]
        c = z[i]
        P[a,b,c] = true
        if a>1 && !P[a-1,b,c]
            push!(new_x, a-1)
            push!(new_y, b)
            push!(new_z, c)
        end
        if a<n && !P[a+1,b,c]
            push!(new_x, a+1)
            push!(new_y, b)
            push!(new_z, c)
        end
        if b>1 && !P[a,b-1,c]
            push!(new_x, a)
            push!(new_y, b-1)
            push!(new_z, c)
        end
        if b<n && !P[a,b+1,c]
            push!(new_x, a)
            push!(new_y, b+1)
            push!(new_z, c)
        end
        if c>1 && !P[a,b,c-1]
            push!(new_x, a)
            push!(new_y, b)
            push!(new_z, c-1)
        end
        if c<n && !P[a,b,c+1]
            push!(new_x, a)
            push!(new_y, b)
            push!(new_z, c+1)
        end
    end
    return new_x, new_y, new_z
end

"""
    complementCrossingProbability3D(n,p,d, rep)

Calculates an approximate probability to have an up/down crossing on the complement of
a depth d percolation of an n*n grid with probability p, using rep experiments.

# Examples
```julia-repl
julia> complementCrossingProbability3D(2,0.75,3, 100)
0.98
julia> complementCrossingProbability3D(2,0.80,3, 100)
0.86
julia> complementCrossingProbability3D(2,0.85,3, 100)
0.65
julia> complementCrossingProbability3D(2,0.90,3, 100)
0.14
```
"""
function complementCrossingProbability3D(n::Integer,p::Real,d::Integer,rep::Integer)::Real
    acc = Threads.Atomic{Int64}(0)
    Threads.@threads for i in 1:rep
        if complementCrossing(fractalPercolation3D(n,p,d))!=0
            Threads.atomic_add!(acc, 1)
        end
    end
    return acc[]/rep
end

"""
    complementCrossingLength3D(n,p,d, rep)

Calculates an approximate length of an up/down crossing (when existing) in the complement of 
a depth d percolation of an n*n grid with probability p, using rep experiments.

# Examples
```julia-repl
julia> complementCrossingLength3D(2,0.60,3, 100)
8.0
julia> complementCrossingLength3D(2,0.70,3, 100)
8.17
julia> complementCrossingLength3D(2,0.80,3, 100)
8.852272727272727
julia> complementCrossingLength3D(2,0.90,3, 100)
9.125
```
"""
function complementCrossingLength3D(n::Integer,p::Real,d::Integer,rep::Integer)::Real
    nc = Threads.Atomic{Int64}(0)
    lc = Threads.Atomic{Int64}(0)
    Threads.@threads for i in 1:rep
        l = complementCrossing(fractalPercolation3D(n,p,d))
        if l!=0
            Threads.atomic_add!(nc, 1)
            Threads.atomic_add!(lc, l)
        end
    end
    return lc[]/nc[]
end

"""
    complementCrossingData3D(n,p,d, rep)

Calculates an approximate length of an up/down crossing (when existing) on the complement of 
a depth d percolation of an n*n grid with probability p, using rep experiments.

# Examples
```julia-repl
julia> complementCrossingData3D(2,0.80,3, 100)
(736, 83, 26560)
julia> complementCrossingData3D(2,0.85,3, 100)
(510, 57, 31432)
julia> complementCrossingData3D(2,0.90,3, 100)
(177, 20, 37048)
julia> complementCrossingData3D(2,0.95,3, 100)
(16, 2, 43520)
```
"""
function complementCrossingData3D(n::Integer,p::Real,d::Integer,rep::Integer)::Tuple{Int64,Int64,Int64}
    nc = Threads.Atomic{Int64}(0)
    lc = Threads.Atomic{Int64}(0)
    sq = Threads.Atomic{Int64}(0)
    Threads.@threads for i in 1:rep
        P = fractalPercolation3D(n,p,d)
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




function saveComplementCrossingSmartData3D(n::Integer, d::Integer, rep::Integer, fileName::String)
    smartSaveCrossingData(complementCrossingData3D, n,d, rep, fileName)
end

rep = 50000
file_name = "complement_crossings_3D_"*string(rep)*".csv"
entitleFile(file_name, "rep,n,d,p,nc,lc,sq")

saveComplementCrossingSmartData3D(2, 1, rep, file_name)
saveComplementCrossingSmartData3D(2, 2, rep, file_name)
saveComplementCrossingSmartData3D(2, 3, rep, file_name)
saveComplementCrossingSmartData3D(2, 4, rep, file_name)
saveComplementCrossingSmartData3D(2, 5, rep, file_name)

# saveComplementCrossingSmartData3D(3, 1, rep, file_name)
# saveComplementCrossingSmartData3D(3, 2, rep, file_name)
# saveComplementCrossingSmartData3D(3, 3, rep, file_name)

# saveComplementCrossingSmartData3D(5, 1, rep, file_name)
# saveComplementCrossingSmartData3D(5, 2, rep, file_name)

# saveComplementCrossingSmartData3D(6, 1, rep, file_name)
# saveComplementCrossingSmartData3D(7, 1, rep, file_name)
# saveComplementCrossingSmartData3D(8, 1, rep, file_name)
# saveComplementCrossingSmartData3D(9, 1, rep, file_name)
# saveComplementCrossingSmartData3D(10, 1, rep, file_name)
# saveComplementCrossingSmartData3D(11, 1, rep, file_name)
# saveComplementCrossingSmartData3D(12, 1, rep, file_name)
# saveComplementCrossingSmartData3D(13, 1, rep, file_name)
# saveComplementCrossingSmartData3D(14, 1, rep, file_name)
# saveComplementCrossingSmartData3D(15, 1, rep, file_name)
# saveComplementCrossingSmartData3D(20, 1, rep, file_name)
# saveComplementCrossingSmartData3D(25, 1, rep, file_name)
# saveComplementCrossingSmartData3D(30, 1, rep, file_name)

