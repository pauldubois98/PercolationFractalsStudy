include("save_utils.jl")
include("fractal_percolation2D.jl")


function custom(t::Tuple{Float64,Float64})::Float64
    return t[1]
end
"""
    intersectionLength2D(n,d,a)

Calculates the length of intervals corresponding to intersections of the line going through the origin 
with angle a to horizontal with each square of a n^d*n^d grid on the unit square.

# Examples
```julia-repl
julia> intersectionLength2D(2,2,pi/6)
4×4 Array{Float64,2}:
 0.288675  0.211325   0.0       0.0
 0.0       0.0773503  0.0       0.0
 0.0       0.288675   0.133975  0.0
 0.0       0.0        0.154701  0.0

julia> intersectionLength2D(3,1,pi/6)
3×3 Array{Float64,2}:
 0.3849  0.281766  0.0
 0.0     0.103134  0.0
 0.0     0.3849    0.178633
```
"""
function intersectionLength2D(n::Integer, d::Integer, a::Real)::Array{Float64,2}
    L = zeros((n^d,n^d))
    m = n^d
    if a==0
        for i in 1:m
            L[i,1] = 1/m
        end
        return L
    end
    if a==pi/2
        for i in 1:m
            L[1,i] = 1/m
        end
        return L
    end
    for i in 1:m
        for j in 1:m
            if (j/m) > tan(a)*(i-1)/m  &&  ((j-1)/m) < tan(a)*i/m
                if ((j-1)/m) < tan(a)*(i-1)/m
                    x1 = (i-1)/m
                    y1 = tan(a)*x1
                else
                    y1 = (j-1)/m
                    x1 = y1/tan(a)
                end
                if (j/m) > tan(a)*i/m
                    x2 = i/m
                    y2 = tan(a)*x2
                else
                    y2 = j/m
                    x2 = y2/tan(a)
                end
                L[i,j] = sqrt( (x2-x1)^2 +  (y2-y1)^2 )
            end
        end
    end
    return L
end



"""
    intersection(P,L)

Calculates the intersection of P using intersection length L.
Returns a 1-dimensional array of 2-Tuples, corresponding to each interval.

# Example
```julia-repl
julia> P = fractalPercolation2D(2, 0.5, 2)
4×4 BitArray{2}:
 1  1  0  0
 1  0  0  0
 1  0  1  0
 1  0  0  0
julia>  L = intersectionLength2D(2,2,pi/4)
4×4 Array{Float64,2}:
 0.353553  6.20634e-17  0.0          0.0
 0.0       0.353553     0.0          0.0
 0.0       1.24127e-16  0.353553     0.0
 0.0       0.0          2.48253e-16  0.353553
julia> intersection(P,L)
0.7071067811865475
```
"""
function intersection(P::BitArray{2}, L::Array{Float64,2})::Real
    l = 0.0
    m = size(P, 1)
    for i in 1:m
        for j in 1:m
            if P[i,j]
                l += L[i,j]
            end
        end
    end
    return l
end



"""
    averageIntersectionLength(n,d, p, angles, rep)

Calculates the approximate length of the intersection of the line going through the origin with angle a 
to horizontal and the n*n grid percolation, depth d with probability p, using rep experiments.

# Example
```julia-repl
julia> angles = collect(LinRange(0,pi/2,7))
julia> averageIntersectionLength(2,2, 0.7, angles, 100)
7-element Array{Float64,1}:
 0.4475
 0.42187504351710836
 0.5078609774652336
 0.6363961030678926
 0.5189934640057522
 0.4408717039293104
 0.4625
``` 
"""
function averageIntersectionLength(n::Integer,d::Integer, p::Real, angles::Array{Float64,1}, rep::Integer)::Array{Float64,1}
    m = length(angles)
    Ls = [intersectionLength2D(n,d, a) for a in angles]
    interLength = Array{Threads.Atomic{Float64}, 1}( [Threads.Atomic{Float64}(0.0) for a in 1:m] )
    Threads.@threads for i in 1:rep
        P = fractalPercolation2D(n,p,d)
        for j in 1:m
            Threads.atomic_add!(interLength[j], Float64( intersection(P, Ls[j]) ))
        end
    end
    return [interLength[j][] for j in 1:m]/rep
end



function saveSmartAverageIntersectionLength(n::Integer, d::Integer, angles::Array{Float64,1}, rep::Integer, fileName::String)
    println("n=",n, " d=",d, " rep=",rep)
    f = open(fileName, "a")
    p = -0.01
    while p<1
        p += 0.01
        pl = averageIntersectionLength(n,d,p, angles, rep)
        println(f, string(rep)*','*string(n)*','*string(d)*','*string(p)*','*string(pl)[2:end-1])
    end
    p=1
    pl = averageIntersectionLength(n,d,p, angles, rep)
    println(f, string(rep)*','*string(n)*','*string(d)*','*string(p)*','*string(pl)[2:end-1])
    close(f)
end






println(Threads.nthreads())


# P = fractalPercolation2D(2, 0.5, 2)
# L = intersectionLength2D(2,2,pi/6)
# I = intersectionLength2D(2,2,pi/2)
# println( intersection(P, L) )
# println( intersection(P, I) )

# angles = collect(LinRange(0,pi/2,46))
# for a in angles
#     println(a, ' ', sum(intersectionLength2D(3,1,a)), ' ', min(1/cos(a), 1/sin(a)) )
# end
# println(averageIntersectionLength(3,1,1, angles, 5000))
# @time averageIntersectionLength(2,4,0.5, angles, 5000)

rep = 50000
angle_step = 3
angles = collect(0:angle_step:45)*pi/(2*90)

file_name = "intersections_2D_"*string(rep)*".csv"
entitleFile(file_name, "rep,n,d,p,"*join(["a="*string(a) for a in collect(0:angle_step:90)], ","))


saveSmartAverageIntersectionLength(2, 1, angles, rep, file_name)
saveSmartAverageIntersectionLength(2, 2, angles, rep, file_name)
saveSmartAverageIntersectionLength(2, 3, angles, rep, file_name)
saveSmartAverageIntersectionLength(2, 4, angles, rep, file_name)
saveSmartAverageIntersectionLength(2, 5, angles, rep, file_name)
saveSmartAverageIntersectionLength(2, 6, angles, rep, file_name)
saveSmartAverageIntersectionLength(2, 7, angles, rep, file_name)
saveSmartAverageIntersectionLength(2, 8, angles, rep, file_name)

saveSmartAverageIntersectionLength(3, 1, angles, rep, file_name)
saveSmartAverageIntersectionLength(3, 2, angles, rep, file_name)
saveSmartAverageIntersectionLength(3, 3, angles, rep, file_name)
saveSmartAverageIntersectionLength(3, 4, angles, rep, file_name)
saveSmartAverageIntersectionLength(3, 5, angles, rep, file_name)

saveSmartAverageIntersectionLength(5, 1, angles, rep, file_name)
saveSmartAverageIntersectionLength(5, 2, angles, rep, file_name)
saveSmartAverageIntersectionLength(5, 3, angles, rep, file_name)

saveSmartAverageIntersectionLength(7, 1, angles, rep, file_name)
saveSmartAverageIntersectionLength(7, 2, angles, rep, file_name)

saveSmartAverageIntersectionLength(11, 1, angles, rep, file_name)
saveSmartAverageIntersectionLength(11, 2, angles, rep, file_name)

saveSmartAverageIntersectionLength(13, 1, angles, rep, file_name)
saveSmartAverageIntersectionLength(13, 2, angles, rep, file_name)

saveSmartAverageIntersectionLength(17, 1, angles, rep, file_name)
saveSmartAverageIntersectionLength(17, 2, angles, rep, file_name)

saveSmartAverageIntersectionLength(20, 1, angles, rep, file_name)

saveSmartAverageIntersectionLength(25, 1, angles, rep, file_name)
saveSmartAverageIntersectionLength(50, 1, angles, rep, file_name)
saveSmartAverageIntersectionLength(75, 1, angles, rep, file_name)
saveSmartAverageIntersectionLength(100, 1, angles, rep, file_name)
saveSmartAverageIntersectionLength(125, 1, angles, rep, file_name)
saveSmartAverageIntersectionLength(150, 1, angles, rep, file_name)
saveSmartAverageIntersectionLength(175, 1, angles, rep, file_name)
saveSmartAverageIntersectionLength(200, 1, angles, rep, file_name)

