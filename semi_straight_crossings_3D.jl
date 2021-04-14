include("save_utils.jl")
include("fractal_percolation3D.jl")



"""
    semiStraightCrossing3D(P)

Tells if there is an up/down crossing in the percolation P, with no back step.

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
julia> semiStraightCrossing3D(P)
0
```
"""
function semiStraightCrossing3D(P::BitArray{3})::Integer
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
        x,y,z = semiNeighbors!(P, n, x,y,z)
        c+=1
    end
    if any(n in z)
        return c
    else
        return 0
    end
end
function semiNeighbors!(P::BitArray{3}, n::Integer, x::Array{<:Integer,1}, y::Array{<:Integer,1}, z::Array{<:Integer,1})
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
        ### no back step
        # if c>1 && P[a,b,c-1]
        #     push!(new_x, a)
        #     push!(new_y, b)
        #     push!(new_z, c-1)
        # end
        if c<n && P[a,b,c+1]
            push!(new_x, a)
            push!(new_y, b)
            push!(new_z, c+1)
        end
    end
    return new_x, new_y, new_z
end




"""
    semiStraightCrossingProbability3D(n,p,d, rep)

Calculates an approximate probability to have a straight up/down crossing 
in a depth d percolation of an n*n grid with probability p, using rep experiments.

# Examples
```julia-repl
julia> semiStraightCrossingProbability3D(2,0.40,3, 1000)
0.006
julia> semiStraightCrossingProbability3D(2,0.50,3, 1000)
0.09
julia> semiStraightCrossingProbability3D(2,0.60,3, 1000)
0.467
julia> semiStraightCrossingProbability3D(2,0.70,3, 1000)
0.844
julia> semiStraightCrossingProbability3D(2,0.80,3, 1000)
0.985
julia> semiStraightCrossingProbability3D(2,0.90,3, 1000)
0.999
```
"""
function semiStraightCrossingProbability3D(n::Integer,p::Real,d::Integer,rep::Integer)::Real
    acc = Threads.Atomic{Int64}(0)
    Threads.@threads for i in 1:rep
        if semiStraightCrossing3D(fractalPercolation3D(n,p,d))>0
            Threads.atomic_add!(acc, 1)
        end
    end
    return acc[]/rep
end


"""
    semiStraightCrossingData3D(n,p,d, rep)

Calculates an approximate length of an up/down crossing (when existing)
in a depth d percolation of an n*n grid with probability p, using rep experiments.

# Examples
```julia-repl
julia> semiStraightCrossingData3D(2,0.40,3, 1000)
(64, 8, 33534)
julia> semiStraightCrossingData3D(2,0.50,3, 1000)
(784, 98, 64040)
julia> semiStraightCrossingData3D(2,0.60,3, 1000)
(3664, 458, 110907)
julia> semiStraightCrossingData3D(2,0.70,3, 1000)
(6952, 869, 177712)
julia> semiStraightCrossingData3D(2,0.80,3, 1000)
(7832, 979, 260116)
julia> semiStraightCrossingData3D(2,0.90,3, 1000)
(7992, 999, 372966)
```
"""
function semiStraightCrossingData3D(n::Integer,p::Real,d::Integer,rep::Integer)::Tuple{Int64,Int64,Int64}
    nc = Threads.Atomic{Int64}(0)
    lc = Threads.Atomic{Int64}(0)
    sq = Threads.Atomic{Int64}(0)
    Threads.@threads for i in 1:rep
        P = fractalPercolation3D(n,p,d)
        s = sum(P)
        c = semiStraightCrossing3D(P)
        if c>0
            Threads.atomic_add!(nc, 1)
            Threads.atomic_add!(lc, c)
        end
        Threads.atomic_add!(sq, s)
    end
    return (lc[], nc[], sq[])
end



function saveSemiStraightCrossingSmartData3D(n::Integer, d::Integer, rep::Integer, fileName::String)
    smartSaveCrossingData(semiStraightCrossingData3D, n,d, rep, fileName)
end

rep = 50000
file_name = "crossings_semi_straight_3D_"*string(rep)*".csv"
entitleFile(file_name, "rep,n,d,p,nc,lc,sq")

# saveSemiStraightCrossingSmartData3D(2, 1, rep, file_name)
# saveSemiStraightCrossingSmartData3D(2, 2, rep, file_name)
# saveSemiStraightCrossingSmartData3D(2, 3, rep, file_name)
# saveSemiStraightCrossingSmartData3D(2, 4, rep, file_name)
# saveSemiStraightCrossingSmartData3D(2, 5, rep, file_name)

# saveSemiStraightCrossingSmartData3D(3, 1, rep, file_name)
# saveSemiStraightCrossingSmartData3D(3, 2, rep, file_name)
# saveSemiStraightCrossingSmartData3D(3, 3, rep, file_name)

# saveSemiStraightCrossingSmartData3D(5, 1, rep, file_name)
# saveSemiStraightCrossingSmartData3D(5, 2, rep, file_name)

# saveSemiStraightCrossingSmartData3D(6, 1, rep, file_name)
# saveSemiStraightCrossingSmartData3D(7, 1, rep, file_name)
# saveSemiStraightCrossingSmartData3D(8, 1, rep, file_name)
# saveSemiStraightCrossingSmartData3D(9, 1, rep, file_name)
# saveSemiStraightCrossingSmartData3D(10, 1, rep, file_name)
# saveSemiStraightCrossingSmartData3D(11, 1, rep, file_name)
# saveSemiStraightCrossingSmartData3D(12, 1, rep, file_name)
# saveSemiStraightCrossingSmartData3D(13, 1, rep, file_name)
# saveSemiStraightCrossingSmartData3D(14, 1, rep, file_name)
# saveSemiStraightCrossingSmartData3D(15, 1, rep, file_name)
# saveSemiStraightCrossingSmartData3D(20, 1, rep, file_name)
# saveSemiStraightCrossingSmartData3D(25, 1, rep, file_name)
# saveSemiStraightCrossingSmartData3D(30, 1, rep, file_name)

