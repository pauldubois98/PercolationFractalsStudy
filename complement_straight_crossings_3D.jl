include("save_utils.jl")
include("fractal_percolation3D.jl")

"""
    straightComplementCrossing(P)

Tells if there is an up/down straight crossing in the percolation complement.

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
julia> straightComplementCrossing(P)
true
```
"""
function straightComplementCrossing(P::BitArray{3})::Bool
    return any(all(P.==0, dims=3))
end



"""
    straightComplementCrossingProbability3D(n,p,d, rep)

Calculates an approximate probability to have a straight up/down crossing in the complement of 
a depth d percolation of an n*n grid with probability p, using rep experiments.

# Examples
```julia-repl
julia> straightComplementCrossingProbability3D(2,0.60,3, 1000)
0.999
julia> straightComplementCrossingProbability3D(2,0.70,3, 1000)
0.921
julia> straightComplementCrossingProbability3D(2,0.80,3, 1000)
0.496
julia> straightComplementCrossingProbability3D(2,0.90,3, 1000)
0.086
```
"""
function straightComplementCrossingProbability3D(n::Integer,p::Real,d::Integer,rep::Integer)::Real
    acc = Threads.Atomic{Int64}(0)
    Threads.@threads for i in 1:rep
        if straightComplementCrossing(fractalPercolation3D(n,p,d))
            Threads.atomic_add!(acc, 1)
        end
    end
    return acc[]/rep
end


"""
    straightComplementCrossingData3D(n,p,d, rep)

Calculates an approximate length of an up/down crossing (when existing) in the complement of 
a depth d percolation of an n*n grid with probability p, using rep experiments.

# Examples
```julia-repl
julia> straightComplementCrossingData3D(2,0.60,3, 1000)
(7960, 995, 112273)
julia> straightComplementCrossingData3D(2,0.70,3, 1000)
(7224, 903, 173912)
julia> straightComplementCrossingData3D(2,0.80,3, 1000)
(3992, 499, 259539)
julia> straightComplementCrossingData3D(2,0.90,3, 1000)
(752, 94, 375749)
```
"""
function straightComplementCrossingData3D(n::Integer,p::Real,d::Integer,rep::Integer)::Tuple{Int64,Int64,Int64}
    nc = Threads.Atomic{Int64}(0)
    lc = Threads.Atomic{Int64}(0)
    sq = Threads.Atomic{Int64}(0)
    Threads.@threads for i in 1:rep
        P = fractalPercolation3D(n,p,d)
        s = sum(P)
        c = straightComplementCrossing(P)
        if c
            Threads.atomic_add!(nc, 1)
            Threads.atomic_add!(lc, n^d)
        end
        Threads.atomic_add!(sq, s)
    end
    return (lc[], nc[], sq[])
end



function saveStraightComplementCrossingSmartData3D(n::Integer, d::Integer, rep::Integer, fileName::String)
    smartSaveCrossingData(straightComplementCrossingData3D, n,d, rep, fileName)
end

rep = 50000
file_name = "complement_crossings_straight_3D_"*string(rep)*".csv"
entitleFile(file_name, "rep,n,d,p,nc,lc,sq")

# saveStraightComplementCrossingSmartData3D(2, 1, rep, file_name)
# saveStraightComplementCrossingSmartData3D(2, 2, rep, file_name)
# saveStraightComplementCrossingSmartData3D(2, 3, rep, file_name)
# saveStraightComplementCrossingSmartData3D(2, 4, rep, file_name)
# saveStraightComplementCrossingSmartData3D(2, 5, rep, file_name)

# saveStraightComplementCrossingSmartData3D(3, 1, rep, file_name)
# saveStraightComplementCrossingSmartData3D(3, 2, rep, file_name)
# saveStraightComplementCrossingSmartData3D(3, 3, rep, file_name)

# saveStraightComplementCrossingSmartData3D(5, 1, rep, file_name)
# saveStraightComplementCrossingSmartData3D(5, 2, rep, file_name)

# saveStraightComplementCrossingSmartData3D(6, 1, rep, file_name)
# saveStraightComplementCrossingSmartData3D(7, 1, rep, file_name)
# saveStraightComplementCrossingSmartData3D(8, 1, rep, file_name)
# saveStraightComplementCrossingSmartData3D(9, 1, rep, file_name)
# saveStraightComplementCrossingSmartData3D(10, 1, rep, file_name)
# saveStraightComplementCrossingSmartData3D(11, 1, rep, file_name)
# saveStraightComplementCrossingSmartData3D(12, 1, rep, file_name)
# saveStraightComplementCrossingSmartData3D(13, 1, rep, file_name)
# saveStraightComplementCrossingSmartData3D(14, 1, rep, file_name)
# saveStraightComplementCrossingSmartData3D(15, 1, rep, file_name)
# saveStraightComplementCrossingSmartData3D(20, 1, rep, file_name)
# saveStraightComplementCrossingSmartData3D(25, 1, rep, file_name)
# saveStraightComplementCrossingSmartData3D(30, 1, rep, file_name)

