include("save_utils.jl")
include("fractal_percolation3D.jl")

"""
    crossing(P)

Tells if there is an up/down crossing in the percolation P, using sparse variables.

# Example
```julia-repl
julia> P
2×2×2 BitArray{3}:
[:, :, 1] =
 false  false
 false  false

[:, :, 2] =
 false   true
 false  false
julia> crossing(P)
0
```
"""
function crossing(P::BitArray{3})::Integer
    n = size(P)[1]
    x = Int32[]
    y = Int32[]
    z = Int32[]
    for i in 1:n
        for j in 1:n
            if P[i,j,1]
                push!(x, i)
                push!(y, j)
                push!(z, 1)
            end
        end
    end
    c = 1
    while !(n in z) && length(x)>0
        x,y,z = neighbors!(P, n, x,y,z)
        c+=1
    end
    if any(n in z)
        return c
    else
        return 0
    end
end
function neighbors!(P::BitArray{3}, n::Integer, x::Array{<:Integer,1}, y::Array{<:Integer,1}, z::Array{<:Integer,1})
    new_x = Int32[]
    new_y = Int32[]
    new_z = Int32[]
    for i in 1:length(x)
        a = x[i]
        b = y[i]
        c = z[i]
        P[a,b,c] = false
        if a>1 && P[a-1,b,c]
            push!(new_x, a-1)
            push!(new_y, b)
            push!(new_z, c)
        end
        if a<n && P[a+1,b,c]
            push!(new_x, a+1)
            push!(new_y, b)
            push!(new_z, c)
        end
        if b>1 && P[a,b-1,c]
            push!(new_x, a)
            push!(new_y, b-1)
            push!(new_z, c)
        end
        if b<n && P[a,b+1,c]
            push!(new_x, a)
            push!(new_y, b+1)
            push!(new_z, c)
        end
        if c>1 && P[a,b,c-1]
            push!(new_x, a)
            push!(new_y, b)
            push!(new_z, c-1)
        end
        if c<n && P[a,b,c+1]
            push!(new_x, a)
            push!(new_y, b)
            push!(new_z, c+1)
        end
    end
    return new_x, new_y, new_z
end

"""
    crossingProbability3D(n,p,d, rep)

Calculates an approximate probability to have an up/down crossing 
in a depth d percolation of an n*n grid with probability p, using rep experiments.

# Examples
```julia-repl
julia> crossingProbability3D(2,0.50,3, 1000)
0.083
julia> crossingProbability3D(2,0.60,3, 1000)
0.477
julia> crossingProbability3D(2,0.70,3, 1000)
0.834
julia> crossingProbability3D(2,0.80,3, 1000)
0.979
```
"""
function crossingProbability3D(n::Integer,p::Real,d::Integer,rep::Integer)::Real
    acc = Threads.Atomic{Int64}(0)
    Threads.@threads for i in 1:rep
        if crossing(fractalPercolation3D(n,p,d))!=0
            Threads.atomic_add!(acc, 1)
        end
    end
    return acc[]/rep
end

"""
    crossingLength3D(n,p,d, rep)

Calculates an approximate length of an up/down crossing (when existing)
in a depth d percolation of an n*n grid with probability p, using rep experiments.

# Examples
```julia-repl
julia>  crossingLength3D(2,0.40,3, 100)
NaN
julia>  crossingLength3D(2,0.50,3, 100)
12.090909090909092
julia>  crossingLength3D(2,0.60,3, 100)
10.549019607843137
julia>  crossingLength3D(2,0.70,3, 100)
9.123595505617978
julia>  crossingLength3D(2,0.80,3, 100)
8.16161616161616
```
"""
function crossingLength3D(n::Integer,p::Real,d::Integer,rep::Integer)::Real
    nc = Threads.Atomic{Int64}(0)
    lc = Threads.Atomic{Int64}(0)
    Threads.@threads for i in 1:rep
        l = crossing(fractalPercolation3D(n,p,d))
        if l!=0
            Threads.atomic_add!(nc, 1)
            Threads.atomic_add!(lc, l)
        end
    end
    return lc[]/nc[]
end

"""
    crossingData3D(n,p,d, rep)

Calculates an approximate length of an up/down crossing (when existing)
in a depth d percolation of an n*n grid with probability p, using rep experiments.

# Examples
```julia-repl
julia> crossingData3D(2,0.80,3, 100)
(816, 99, 25677)
julia> crossingData3D(2,0.70,3, 100)
(730, 81, 17708)
julia> crossingData3D(2,0.60,3, 100)
(417, 40, 11039)
julia> crossingData3D(2,0.50,3, 100)
(139, 12, 6250)
julia> crossingData3D(2,0.40,3, 100)
(0, 0, 3193)
```
"""
function crossingData3D(n::Integer,p::Real,d::Integer,rep::Integer)::Tuple{Int64,Int64,Int64}
    nc = Threads.Atomic{Int64}(0)
    lc = Threads.Atomic{Int64}(0)
    sq = Threads.Atomic{Int64}(0)
    Threads.@threads for i in 1:rep
        P = fractalPercolation3D(n,p,d)
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




function saveCrossingSmartData3D(n::Integer, d::Integer, rep::Integer, fileName::String)
    smartSaveCrossingData(crossingData3D, n,d, rep, fileName)
end

rep = 50000
file_name = "crossings_3D_"*string(rep)*".csv"
entitleFile(file_name, "rep,n,d,p,nc,lc,sq")

saveCrossingSmartData3D(2, 1, rep, file_name)
# saveCrossingSmartData3D(2, 2, rep, file_name)
# saveCrossingSmartData3D(2, 3, rep, file_name)
# saveCrossingSmartData3D(2, 4, rep, file_name)
# saveCrossingSmartData3D(2, 5, rep, file_name)

# saveCrossingSmartData3D(3, 1, rep, file_name)
# saveCrossingSmartData3D(3, 2, rep, file_name)
# saveCrossingSmartData3D(3, 3, rep, file_name)

# saveCrossingSmartData3D(5, 1, rep, file_name)
# saveCrossingSmartData3D(5, 2, rep, file_name)

# saveCrossingSmartData3D(6, 1, rep, file_name)
# saveCrossingSmartData3D(7, 1, rep, file_name)
# saveCrossingSmartData3D(8, 1, rep, file_name)
# saveCrossingSmartData3D(9, 1, rep, file_name)
# saveCrossingSmartData3D(10, 1, rep, file_name)
# saveCrossingSmartData3D(11, 1, rep, file_name)
# saveCrossingSmartData3D(12, 1, rep, file_name)
# saveCrossingSmartData3D(13, 1, rep, file_name)
# saveCrossingSmartData3D(14, 1, rep, file_name)
# saveCrossingSmartData3D(15, 1, rep, file_name)
# saveCrossingSmartData3D(20, 1, rep, file_name)
# saveCrossingSmartData3D(25, 1, rep, file_name)
# saveCrossingSmartData3D(30, 1, rep, file_name)

