include("save_utils.jl")
include("fractal_percolation3D.jl")

"""
    straightCrossing(P)

Tells if there is an up/down straight crossing in the percolation P.

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
julia> straightCrossing(P)
0
```
"""
function straightCrossing(P::BitArray{3})::Bool
    return any(all(P, dims=3))
end



"""
    straightCrossingProbability3D(n,p,d, rep)

Calculates an approximate probability to have a straight up/down crossing 
in a depth d percolation of an n*n grid with probability p, using rep experiments.

# Examples
```julia-repl
julia> straightCrossingProbability3D(2,0.50,3, 1000)
0.003
julia> straightCrossingProbability3D(2,0.60,3, 1000)
0.038
julia> straightCrossingProbability3D(2,0.70,3, 1000)
0.317
julia> straightCrossingProbability3D(2,0.80,3, 1000)
0.864
julia> straightCrossingProbability3D(2,0.90,3, 1000)
0.996
```
"""
function straightCrossingProbability3D(n::Integer,p::Real,d::Integer,rep::Integer)::Real
    acc = Threads.Atomic{Int64}(0)
    Threads.@threads for i in 1:rep
        if straightCrossing(fractalPercolation3D(n,p,d))
            Threads.atomic_add!(acc, 1)
        end
    end
    return acc[]/rep
end


"""
    straightCrossingData3D(n,p,d, rep)

Calculates an approximate length of an up/down crossing (when existing)
in a depth d percolation of an n*n grid with probability p, using rep experiments.

# Examples
```julia-repl
julia> straightCrossingData3D(2,0.50,3, 1000)
(64, 8, 64909)
julia> straightCrossingData3D(2,0.60,3, 1000)
(384, 48, 109791)
julia> straightCrossingData3D(2,0.70,3, 1000)
(2664, 333, 176196)
julia> straightCrossingData3D(2,0.80,3, 1000)
(6904, 863, 264204)
julia> straightCrossingData3D(2,0.90,3, 1000)
(7984, 998, 372132)
```
"""
function straightCrossingData3D(n::Integer,p::Real,d::Integer,rep::Integer)::Tuple{Int64,Int64,Int64}
    nc = Threads.Atomic{Int64}(0)
    lc = Threads.Atomic{Int64}(0)
    sq = Threads.Atomic{Int64}(0)
    Threads.@threads for i in 1:rep
        P = fractalPercolation3D(n,p,d)
        s = sum(P)
        c = straightCrossing(P)
        if c
            Threads.atomic_add!(nc, 1)
            Threads.atomic_add!(lc, n^d)
        end
        Threads.atomic_add!(sq, s)
    end
    return (lc[], nc[], sq[])
end



function saveStraightCrossingSmartData3D(n::Integer, d::Integer, rep::Integer, fileName::String)
    smartSaveCrossingData(straightCrossingData3D, n,d, rep, fileName)
end

rep = 50000
file_name = "crossings_straight_3D_"*string(rep)*".csv"
entitleFile(file_name, "rep,n,d,p,nc,lc,sq")

# saveStraightCrossingSmartData3D(2, 1, rep, file_name)
# saveStraightCrossingSmartData3D(2, 2, rep, file_name)
# saveStraightCrossingSmartData3D(2, 3, rep, file_name)
# saveStraightCrossingSmartData3D(2, 4, rep, file_name)
# saveStraightCrossingSmartData3D(2, 5, rep, file_name)

# saveStraightCrossingSmartData3D(3, 1, rep, file_name)
# saveStraightCrossingSmartData3D(3, 2, rep, file_name)
# saveStraightCrossingSmartData3D(3, 3, rep, file_name)

# saveStraightCrossingSmartData3D(5, 1, rep, file_name)
# saveStraightCrossingSmartData3D(5, 2, rep, file_name)

# saveStraightCrossingSmartData3D(6, 1, rep, file_name)
# saveStraightCrossingSmartData3D(7, 1, rep, file_name)
# saveStraightCrossingSmartData3D(8, 1, rep, file_name)
# saveStraightCrossingSmartData3D(9, 1, rep, file_name)
# saveStraightCrossingSmartData3D(10, 1, rep, file_name)
# saveStraightCrossingSmartData3D(11, 1, rep, file_name)
# saveStraightCrossingSmartData3D(12, 1, rep, file_name)
# saveStraightCrossingSmartData3D(13, 1, rep, file_name)
# saveStraightCrossingSmartData3D(14, 1, rep, file_name)
# saveStraightCrossingSmartData3D(15, 1, rep, file_name)
# saveStraightCrossingSmartData3D(20, 1, rep, file_name)
# saveStraightCrossingSmartData3D(25, 1, rep, file_name)
# saveStraightCrossingSmartData3D(30, 1, rep, file_name)

