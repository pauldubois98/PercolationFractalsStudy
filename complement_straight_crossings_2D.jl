include("save_utils.jl")
include("fractal_percolation2D.jl")

"""
    straightComplementCrossing(P)

Tells if there is an up/down straight crossing in the percolation complement.

# Example
```julia-repl
julia> P
5×5 BitArray{2}:
 1  1  1  0  0
 1  1  0  1  0
 0  0  1  1  0
 0  1  1  1  0
 0  1  1  1  0
julia> straightComplementCrossing(P)
true
julia> Q
5×5 BitArray{2}:
 1  1  0  0  0
 1  1  0  1  1
 1  0  1  1  1
 0  1  1  1  1
 1  1  1  1  1
julia> straightComplementCrossing(Q)
false
```
"""
function straightComplementCrossing(P::BitArray{2})::Integer
    return any(all(P.==0, dims=1))
end



"""
    straightComplementCrossingData(n,p,d, rep)

Calculates an approximate length of an up/down crossing (when existing) in the complement of
a depth d percolation of an n*n grid with probability p, using rep experiments.

# Examples
```julia-repl
julia> straightComplementCrossingData(2,0.90,8, 100)
(768, 3, 2832856)
julia> straightComplementCrossingData(2,0.80,8, 100)
(6144, 24, 1178950)
julia> straightComplementCrossingData(2,0.70,8, 100)
(22016, 86, 368166)
julia> straightComplementCrossingData(2,0.60,8, 100)
(25600, 100, 112254)
```
"""
function straightComplementCrossingData(n::Integer,p::Real,d::Integer,rep::Integer)::Tuple{Int64,Int64,Int64}
    nc = Threads.Atomic{Int64}(0)
    sq = Threads.Atomic{Int64}(0)
    Threads.@threads for i in 1:rep
        P = fractalPercolation2D(n,p,d)
        s = sum(P)
        l = straightComplementCrossing(P)
        if l
            Threads.atomic_add!(nc, 1)
        end
        Threads.atomic_add!(sq, s)
    end
    lc = nc[]*(n^d)
    return (lc, nc[], sq[])
end



function saveStraightComplementCrossingSmartData2D(n::Integer, d::Integer, rep::Integer, fileName::String)
    smartSaveCrossingData(straightComplementCrossingData, n,d, rep, fileName)
end

rep = 50000
file_name = "complement_crossings_straight_2D_"*string(rep)*".csv"
entitleFile(file_name, "rep,n,d,p,nc,lc,sq")


saveStraightComplementCrossingSmartData2D(2, 1, rep, file_name)
saveStraightComplementCrossingSmartData2D(2, 2, rep, file_name)
saveStraightComplementCrossingSmartData2D(2, 3, rep, file_name)
saveStraightComplementCrossingSmartData2D(2, 4, rep, file_name)
saveStraightComplementCrossingSmartData2D(2, 5, rep, file_name)
saveStraightComplementCrossingSmartData2D(2, 6, rep, file_name)
saveStraightComplementCrossingSmartData2D(2, 7, rep, file_name)
saveStraightComplementCrossingSmartData2D(2, 8, rep, file_name)

saveStraightComplementCrossingSmartData2D(3, 1, rep, file_name)
saveStraightComplementCrossingSmartData2D(3, 2, rep, file_name)
saveStraightComplementCrossingSmartData2D(3, 3, rep, file_name)
saveStraightComplementCrossingSmartData2D(3, 4, rep, file_name)
saveStraightComplementCrossingSmartData2D(3, 5, rep, file_name)

saveStraightComplementCrossingSmartData2D(5, 1, rep, file_name)
saveStraightComplementCrossingSmartData2D(5, 2, rep, file_name)
saveStraightComplementCrossingSmartData2D(5, 3, rep, file_name)

saveStraightComplementCrossingSmartData2D(7, 1, rep, file_name)
saveStraightComplementCrossingSmartData2D(7, 2, rep, file_name)

saveStraightComplementCrossingSmartData2D(11, 1, rep, file_name)
saveStraightComplementCrossingSmartData2D(11, 2, rep, file_name)

saveStraightComplementCrossingSmartData2D(13, 1, rep, file_name)
saveStraightComplementCrossingSmartData2D(13, 2, rep, file_name)

saveStraightComplementCrossingSmartData2D(17, 1, rep, file_name)
saveStraightComplementCrossingSmartData2D(17, 2, rep, file_name)

saveStraightComplementCrossingSmartData2D(25, 1, rep, file_name)
saveStraightComplementCrossingSmartData2D(50, 1, rep, file_name)
saveStraightComplementCrossingSmartData2D(75, 1, rep, file_name)
saveStraightComplementCrossingSmartData2D(100, 1, rep, file_name)
saveStraightComplementCrossingSmartData2D(125, 1, rep, file_name)
saveStraightComplementCrossingSmartData2D(150, 1, rep, file_name)
saveStraightComplementCrossingSmartData2D(175, 1, rep, file_name)
saveStraightComplementCrossingSmartData2D(200, 1, rep, file_name)
