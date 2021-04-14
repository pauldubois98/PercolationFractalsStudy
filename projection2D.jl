include("fractal_percolation2D.jl")

"""
    projectionIntervals(n,d,a)

Calculates the intervals projections corresponding to each square of a n^d*n^d grid on the unit square.
Returns a 2-dimensional array of 2-Tuples, corresponding to each interval.

# Examples
```julia-repl
julia> I = projectionIntervals(2,2,pi/3)
4×4 Array{Tuple{Float64,Float64},2}:
 (0.0, 0.341506)    (0.216506, 0.558013)  (0.433013, 0.774519)  (0.649519, 0.991025)
 (0.125, 0.466506)  (0.341506, 0.683013)  (0.558013, 0.899519)  (0.774519, 1.11603)
 (0.25, 0.591506)   (0.466506, 0.808013)  (0.683013, 1.02452)   (0.899519, 1.24103)
 (0.375, 0.716506)  (0.591506, 0.933013)  (0.808013, 1.14952)   (1.02452, 1.36603)

julia> I = projectionIntervals(2,2,pi/4)
4×4 Array{Tuple{Float64,Float64},2}:
 (0.0, 0.353553)       (0.176777, 0.53033)   (0.353553, 0.707107)  (0.53033, 0.883883)
 (0.176777, 0.53033)   (0.353553, 0.707107)  (0.53033, 0.883883)   (0.707107, 1.06066)
 (0.353553, 0.707107)  (0.53033, 0.883883)   (0.707107, 1.06066)   (0.883883, 1.23744)
 (0.53033, 0.883883)   (0.707107, 1.06066)   (0.883883, 1.23744)   (1.06066, 1.41421)
```
"""
function projectionIntervals(n::Integer, d::Integer, a::Real)::Array{Tuple{Float64,Float64},2}
    left = Array{Float64,2}(undef, (n^d,n^d))
    right = Array{Float64,2}(undef, (n^d,n^d))
    m = n^d
    for i in 1:m-1
        for j in 1:m-1
            x = i/m
            y = j/m
            r = sqrt(x^2+y^2)
            t = atan(y/x)
            p = r*cos(t-a)
            right[i,j] = p
            left[i+1,j+1] = p
        end
    end
    for i in 1:m-1
        x = 1
        y = i/m
        r = sqrt(x^2+y^2)
        t = atan(y/x)
        right[m,i] = r*cos(t-a)
        x = i/m
        y = 1
        r = sqrt(x^2+y^2)
        t = atan(y/x)
        right[i,m] = r*cos(t-a)
        x = 0
        y = i/m
        r = sqrt(x^2+y^2)
        t = atan(y/x)
        left[1,i+1] = r*cos(t-a)
        x = i/m
        y = 0
        r = sqrt(x^2+y^2)
        t = atan(y/x)
        left[i+1,1] = r*cos(t-a)
    end
    x = 1
    y = 1
    r = sqrt(x^2+y^2)
    t = atan(y/x)
    right[m,m] = r*cos(t-a)
    # x = 1
    # y = 1
    # r = sqrt(x^2+y^2)
    # t = atan(y/x)
    # p = r*cos(t-a)
    left[1,1] = 0
    return collect(zip(left, right))
end

"""
    projection(P,I)

Calculates the projection of P using interval list I.
Returns a 1-dimensional array of 2-Tuples, corresponding to each interval.

# Example
```julia-repl
julia> P = fractalPercolation2D(2, 0.5, 2)
4×4 BitArray{2}:
 0  1  1  1
 1  1  0  0
 0  0  0  0
 0  0  1  1
julia> I = projectionIntervals(2,2,pi/4)
4×4 Array{Tuple{Float64,Float64},2}:
 (0.0, 0.353553)       (0.176777, 0.53033)   (0.353553, 0.707107)  (0.53033, 0.883883)
 (0.176777, 0.53033)   (0.353553, 0.707107)  (0.53033, 0.883883)   (0.707107, 1.06066)
 (0.353553, 0.707107)  (0.53033, 0.883883)   (0.707107, 1.06066)   (0.883883, 1.23744)
 (0.53033, 0.883883)   (0.707107, 1.06066)   (0.883883, 1.23744)   (1.06066, 1.41421)
julia> projection(P, I)
3-element Array{Tuple{Float64,Float64},1}:
 (0.1767766952966369, 0.5303300858899106)
 (0.5303300858899107, 0.7071067811865476)
 (1.0606601717798212, 1.4142135623730951)
```
"""
function projection(P::BitArray{2}, I::Array{Tuple{Float64,Float64},2})::Array{Tuple{Float64,Float64},1}
    proj = Tuple{Float64,Float64}[]
    m = size(P, 1)
    for i in 1:m
        for j in 1:m
            if P[i,j]
                push!(proj, I[i,j])
            end
        end
    end
    sort!(proj)
    n = length(proj)
    k = 1
    while k<n
        if proj[k][2]>=proj[k+1][1]
            proj[k] = (min(proj[k][1],proj[k+1][1]), max(proj[k][2],proj[k+1][2]))
            deleteat!(proj, k+1)
            n -= 1
        else
            k += 1
        end
    end
    return proj
end

"""
    lengthUnionIntervals(I)

Calculates the length of the union of the intervals I.

# Example
```julia-repl
julia> I
2-element Array{Tuple{Float64,Float64},1}:
 (0.0, 0.53)
 (0.58, 0.88)
julia> lengthUnionIntervals(I)
0.83
```
"""
function lengthUnionIntervals(I::Array{Tuple{Float64,Float64},1})::Real
    l = 0
    for k in 1:length(I)
        l += I[k][2]-I[k][1]
    end
    return l
end


"""
crossingData(n,p,d, rep)

Calculates an approximate length of an up/down crossing (when existing)
in a depth d percolation of an n*n grid with probability p, using rep experiments.

# Example
```julia-repl
julia> angles = collect(LinRange(0,pi/2,7))
julia> averageProjectionLength(2,2,0.5, angles, 100)
7-element Array{Float64,1}:
 0.61
 0.7040424773363486
 0.7540351152517413
 0.7654430906344382
 0.7605303057801243
 0.7092188582383989
 0.6075
``` 
"""
function averageProjectionLength(n::Integer,d::Integer, p::Real, angles::Array{Float64,1}, rep::Integer)::Array{Float64,1}
    m = length(angles)
    Is = [projectionIntervals(n,d, a) for a in angles]
    projLength = Array{Threads.Atomic{Float64}, 1}( [Threads.Atomic{Float64}(0.0) for a in 1:m] )
    Threads.@threads for i in 1:rep
        P = fractalPercolation2D(n,p,d)
        for j in 1:m
            Threads.atomic_add!(projLength[j], Float64( lengthUnionIntervals(projection(P, Is[j])) ))
        end
    end
    return [projLength[j][] for j in 1:m]/rep
end



function saveSmartAverageProjectionLength(n::Integer, d::Integer, angles::Array{Float64,1}, rep::Integer, fileName::String)
    println("n=",n, " d=",d, " rep=",rep)
    f = open(fileName, "a")
    p = -0.01
    l = 0
    while l<1 && p<=1
        p += 0.01
        pl = averageProjectionLength(n,d,p, angles, rep)
        println(f, string(rep)*','*string(n)*','*string(d)*','*string(p)*','*string(pl)[2:end-1])
    end
    while p<1
        p += 0.1
        pl = averageProjectionLength(n,d,p, angles, rep)
        println(f, string(rep)*','*string(n)*','*string(d)*','*string(p)*','*string(pl)[2:end-1])
    end
    p=1
    pl = averageProjectionLength(n,d,p, angles, rep)
    println(f, string(rep)*','*string(n)*','*string(d)*','*string(p)*','*string(pl)[2:end-1])
    close(f)
end








println(Threads.nthreads())


# P = fractalPercolation2D(2, 0.5, 2)
# I = projectionIntervals(2,2,pi/4)
# I = projectionIntervals(2,2,pi/2)
# proj = projection(P, I)
# println(lengthInterval(proj))

# angles = collect(LinRange(0,pi/2,46))
# @time averageProjectionLength(2,4,0.5, angles, 5000)



rep = 50000
step = 3
angles = collect(0:step:45)*pi/180

file_name = "projections_2D_"*string(rep)*".csv"


try
    local f
    f = open(file_name, "r")
    inside = read(f,1)
    close(f)
    if inside==UInt8[]
        f = open(file_name, "a")
        join(["a="*string(a) for a in collect(0:step:90)], ",")
        println(f, "rep,n,d,p,"*join(["a="*string(a) for a in collect(0:2:90)], ","))
        close(f)
    end
catch e
    local f
    f = open(file_name, "a")
    join(["a="*string(a) for a in collect(0:step:90)], ",")
    println(f, "rep,n,d,p,"*join(["a="*string(a) for a in collect(0:2:90)], ","))
    close(f)    
end



saveSmartAverageProjectionLength(2, 1, angles, rep, file_name)
saveSmartAverageProjectionLength(2, 2, angles, rep, file_name)
saveSmartAverageProjectionLength(2, 3, angles, rep, file_name)
saveSmartAverageProjectionLength(2, 4, angles, rep, file_name)
saveSmartAverageProjectionLength(2, 5, angles, rep, file_name)
saveSmartAverageProjectionLength(2, 6, angles, rep, file_name)
saveSmartAverageProjectionLength(2, 7, angles, rep, file_name)
saveSmartAverageProjectionLength(2, 8, angles, rep, file_name)

saveSmartAverageProjectionLength(3, 1, angles, rep, file_name)
saveSmartAverageProjectionLength(3, 2, angles, rep, file_name)
saveSmartAverageProjectionLength(3, 3, angles, rep, file_name)
saveSmartAverageProjectionLength(3, 4, angles, rep, file_name)
saveSmartAverageProjectionLength(3, 5, angles, rep, file_name)

saveSmartAverageProjectionLength(5, 1, angles, rep, file_name)
saveSmartAverageProjectionLength(5, 2, angles, rep, file_name)
saveSmartAverageProjectionLength(5, 3, angles, rep, file_name)

saveSmartAverageProjectionLength(7, 1, angles, rep, file_name)
saveSmartAverageProjectionLength(7, 2, angles, rep, file_name)

saveSmartAverageProjectionLength(11, 1, angles, rep, file_name)
saveSmartAverageProjectionLength(11, 2, angles, rep, file_name)

saveSmartAverageProjectionLength(13, 1, angles, rep, file_name)
saveSmartAverageProjectionLength(13, 2, angles, rep, file_name)

saveSmartAverageProjectionLength(17, 1, angles, rep, file_name)
saveSmartAverageProjectionLength(17, 2, angles, rep, file_name)

saveSmartAverageProjectionLength(20, 1, angles, rep, file_name)

saveSmartAverageProjectionLength(25, 1, angles, rep, file_name)
saveSmartAverageProjectionLength(50, 1, angles, rep, file_name)
saveSmartAverageProjectionLength(75, 1, angles, rep, file_name)
saveSmartAverageProjectionLength(100, 1, angles, rep, file_name)
saveSmartAverageProjectionLength(125, 1, angles, rep, file_name)
saveSmartAverageProjectionLength(150, 1, angles, rep, file_name)
saveSmartAverageProjectionLength(175, 1, angles, rep, file_name)
saveSmartAverageProjectionLength(200, 1, angles, rep, file_name)

