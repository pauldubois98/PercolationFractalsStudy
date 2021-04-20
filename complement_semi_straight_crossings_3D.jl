include("save_utils.jl")
include("fractal_percolation3D.jl")



"""
    semiStraightComplementCrossing3D(P)

Tells if there is an up/down crossing in the complement of the percolation P, with no back step.

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
julia> semiStraightComplementCrossing3D(P)
0
```
"""
function semiStraightComplementCrossing3D(P::BitArray{3})::Integer
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
        x,y,z = complementSemiNeighbors!(P, n, x,y,z)
        c+=1
    end
    if any(n in z)
        return c
    else
        return 0
    end
end
function complementSemiNeighbors!(P::BitArray{3}, n::Integer, x::Array{<:Integer,1}, y::Array{<:Integer,1}, z::Array{<:Integer,1})
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
        ### no back step
        # if c>1 && P[a,b,c-1]
        #     push!(new_x, a)
        #     push!(new_y, b)
        #     push!(new_z, c-1)
        # end
        if c<n && !P[a,b,c+1]
            push!(new_x, a)
            push!(new_y, b)
            push!(new_z, c+1)
        end
    end
    return new_x, new_y, new_z
end




"""
    semiStraightComplementCrossingProbability3D(n,p,d, rep)

Calculates an approximate probability to have a straight up/down crossing in the complement of 
a depth d percolation of an n*n grid with probability p, using rep experiments.

# Examples
```julia-repl
julia> semiStraightComplementCrossingProbability3D(2,0.40,3, 1000)
0.006
julia> semiStraightComplementCrossingProbability3D(2,0.50,3, 1000)
0.09
julia> semiStraightComplementCrossingProbability3D(2,0.60,3, 1000)
0.467
julia> semiStraightComplementCrossingProbability3D(2,0.70,3, 1000)
0.844
julia> semiStraightComplementCrossingProbability3D(2,0.80,3, 1000)
0.985
julia> semiStraightComplementCrossingProbability3D(2,0.90,3, 1000)
0.999
```
"""
function semiStraightComplementCrossingProbability3D(n::Integer,p::Real,d::Integer,rep::Integer)::Real
    acc = Threads.Atomic{Int64}(0)
    Threads.@threads for i in 1:rep
        if semiStraightComplementCrossing3D(fractalPercolation3D(n,p,d))>0
            Threads.atomic_add!(acc, 1)
        end
    end
    return acc[]/rep
end


"""
    semiStraightComplementCrossingData3D(n,p,d, rep)

Calculates an approximate length of an up/down crossing (when existing) in the complement of a
a depth d percolation of an n*n grid with probability p, using rep experiments.

# Examples
```julia-repl
julia> semiStraightComplementCrossingData3D(2,0.40,3, 1000)
(64, 8, 33534)
julia> semiStraightComplementCrossingData3D(2,0.50,3, 1000)
(784, 98, 64040)
julia> semiStraightComplementCrossingData3D(2,0.60,3, 1000)
(3664, 458, 110907)
julia> semiStraightComplementCrossingData3D(2,0.70,3, 1000)
(6952, 869, 177712)
julia> semiStraightComplementCrossingData3D(2,0.80,3, 1000)
(7832, 979, 260116)
julia> semiStraightComplementCrossingData3D(2,0.90,3, 1000)
(7992, 999, 372966)
```
"""
function semiStraightComplementCrossingData3D(n::Integer,p::Real,d::Integer,rep::Integer)::Tuple{Int64,Int64,Int64}
    nc = Threads.Atomic{Int64}(0)
    lc = Threads.Atomic{Int64}(0)
    sq = Threads.Atomic{Int64}(0)
    Threads.@threads for i in 1:rep
        P = fractalPercolation3D(n,p,d)
        s = sum(P)
        c = semiStraightComplementCrossing3D(P)
        if c>0
            Threads.atomic_add!(nc, 1)
            Threads.atomic_add!(lc, c)
        end
        Threads.atomic_add!(sq, s)
    end
    return (lc[], nc[], sq[])
end



function saveSemiStraightComplementCrossingSmartData3D(n::Integer, d::Integer, rep::Integer, fileName::String)
    smartSaveCrossingData(semiStraightComplementCrossingData3D, n,d, rep, fileName)
end

rep = 50000
file_name = "complement_crossings_semi_straight_3D_"*string(rep)*".csv"
entitleFile(file_name, "rep,n,d,p,nc,lc,sq")

# saveSemiStraightComplementCrossingSmartData3D(2, 1, rep, file_name)
# saveSemiStraightComplementCrossingSmartData3D(2, 2, rep, file_name)
# saveSemiStraightComplementCrossingSmartData3D(2, 3, rep, file_name)
# saveSemiStraightComplementCrossingSmartData3D(2, 4, rep, file_name)
# saveSemiStraightComplementCrossingSmartData3D(2, 5, rep, file_name)

# saveSemiStraightComplementCrossingSmartData3D(3, 1, rep, file_name)
# saveSemiStraightComplementCrossingSmartData3D(3, 2, rep, file_name)
# saveSemiStraightComplementCrossingSmartData3D(3, 3, rep, file_name)

# saveSemiStraightComplementCrossingSmartData3D(5, 1, rep, file_name)
# saveSemiStraightComplementCrossingSmartData3D(5, 2, rep, file_name)

# saveSemiStraightComplementCrossingSmartData3D(6, 1, rep, file_name)
# saveSemiStraightComplementCrossingSmartData3D(7, 1, rep, file_name)
# saveSemiStraightComplementCrossingSmartData3D(8, 1, rep, file_name)
# saveSemiStraightComplementCrossingSmartData3D(9, 1, rep, file_name)
# saveSemiStraightComplementCrossingSmartData3D(10, 1, rep, file_name)
# saveSemiStraightComplementCrossingSmartData3D(11, 1, rep, file_name)
# saveSemiStraightComplementCrossingSmartData3D(12, 1, rep, file_name)
# saveSemiStraightComplementCrossingSmartData3D(13, 1, rep, file_name)
# saveSemiStraightComplementCrossingSmartData3D(14, 1, rep, file_name)
# saveSemiStraightComplementCrossingSmartData3D(15, 1, rep, file_name)
# saveSemiStraightComplementCrossingSmartData3D(20, 1, rep, file_name)
# saveSemiStraightComplementCrossingSmartData3D(25, 1, rep, file_name)
# saveSemiStraightComplementCrossingSmartData3D(30, 1, rep, file_name)

