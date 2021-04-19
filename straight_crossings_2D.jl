include("save_utils.jl")
include("fractal_percolation2D.jl")

"""
    straightCrossing(P)

Tells if there is an up/down straight crossing in the percolation P.

# Example
```julia-repl
julia> P
5×5 BitArray{2}:
 1  1  1  0  1
 1  1  0  1  1
 0  0  1  1  1
 0  1  1  1  1
 0  1  1  1  1
julia> straightCrossing(P)
true
julia> Q
5×5 BitArray{2}:
 1  1  0  0  0
 1  1  0  1  1
 1  0  1  1  1
 0  1  1  1  1
 1  1  1  1  1
julia> straightCrossing(Q)
false
```
"""
function straightCrossing(P::BitArray{2})::Integer
    return any(all(P, dims=1))
end



"""
    straightCrossingData(n,p,d, rep)

Calculates an approximate length of an up/down crossing (when existing)
in a depth d percolation of an n*n grid with probability p, using rep experiments.

# Examples
```julia-repl
julia> straightCrossingData(2,0.99,8, 100)
(19968, 78, 6018902)
julia> straightCrossingData(2,0.98,8, 100)
(256, 1, 5580265)
julia> straightCrossingData(2,0.97,8, 100)
(0, 0, 5158902)
```
"""
function straightCrossingData(n::Integer,p::Real,d::Integer,rep::Integer)::Tuple{Int64,Int64,Int64}
    nc = Threads.Atomic{Int64}(0)
    sq = Threads.Atomic{Int64}(0)
    Threads.@threads for i in 1:rep
        P = fractalPercolation2D(n,p,d)
        s = sum(P)
        l = straightCrossing(P)
        if l
            Threads.atomic_add!(nc, 1)
        end
        Threads.atomic_add!(sq, s)
    end
    lc = nc[]*(n^d)
    return (lc, nc[], sq[])
end



function saveStraightCrossingSmartData(n::Integer, d::Integer, rep::Integer, fileName::String)
    f = open(fileName, "a")
    p=0
    while p<=1
        p += 0.01
        lc,nc, sq = straightCrossingData(n,p,d, rep)
        println(f, string(rep)*','*string(n)*','*string(d)*','*string(p)*','*string(nc)*','*string(lc)*','*string(sq))
    end
    close(f)
end


rep = 50000
file_name = "blah_crossing_straight_2D_"*string(rep)*".csv"
entitleFile(file_name, "rep,n,d,p,nc,lc,sq")

# saveStraightCrossingSmartData(2, 1, rep, file_name)
# saveStraightCrossingSmartData(2, 2, rep, file_name)
# saveStraightCrossingSmartData(2, 3, rep, file_name)
# saveStraightCrossingSmartData(2, 4, rep, file_name)
# saveStraightCrossingSmartData(2, 5, rep, file_name)
# saveStraightCrossingSmartData(2, 6, rep, file_name)
# saveStraightCrossingSmartData(2, 7, rep, file_name)
# saveStraightCrossingSmartData(2, 8, rep, file_name)

# saveStraightCrossingSmartData(3, 1, rep, file_name)
# saveStraightCrossingSmartData(3, 2, rep, file_name)
# saveStraightCrossingSmartData(3, 3, rep, file_name)
# saveStraightCrossingSmartData(3, 4, rep, file_name)
# saveStraightCrossingSmartData(3, 5, rep, file_name)

# saveStraightCrossingSmartData(5, 1, rep, file_name)
# saveStraightCrossingSmartData(5, 2, rep, file_name)
# saveStraightCrossingSmartData(5, 3, rep, file_name)

# saveStraightCrossingSmartData(7, 1, rep, file_name)
# saveStraightCrossingSmartData(7, 2, rep, file_name)

# saveStraightCrossingSmartData(11, 1, rep, file_name)
# saveStraightCrossingSmartData(11, 2, rep, file_name)

# saveStraightCrossingSmartData(13, 1, rep, file_name)
# saveStraightCrossingSmartData(13, 2, rep, file_name)

# saveStraightCrossingSmartData(17, 1, rep, file_name)
# saveStraightCrossingSmartData(17, 2, rep, file_name)

# saveStraightCrossingSmartData(25, 1, rep, file_name)
# saveStraightCrossingSmartData(50, 1, rep, file_name)
# saveStraightCrossingSmartData(75, 1, rep, file_name)
# saveStraightCrossingSmartData(100, 1, rep, file_name)
# saveStraightCrossingSmartData(125, 1, rep, file_name)
# saveStraightCrossingSmartData(150, 1, rep, file_name)
# saveStraightCrossingSmartData(175, 1, rep, file_name)
# saveStraightCrossingSmartData(200, 1, rep, file_name)
