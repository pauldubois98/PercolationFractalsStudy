include("save_utils.jl")
include("fractal_percolation3D.jl")

"""
    distanceToCenter3D(n,d)

Calculates the distance to center for each cube of a n^d*n^d*n^d grid.

# Examples
```julia-repl
julia> distanceToCenter3D(3,1)
3×3×3 Array{Float64,3}:
[:, :, 1] =
 1.73205  1.41421  1.73205
 1.41421  1.0      1.41421
 1.73205  1.41421  1.73205

[:, :, 2] =
 1.41421  1.0  1.41421
 1.0      0.0  1.0
 1.41421  1.0  1.41421

[:, :, 3] =
 1.73205  1.41421  1.73205
 1.41421  1.0      1.41421
 1.73205  1.41421  1.73205

julia> distanceToCenter3D(2,2)
4×4×4 Array{Float64,3}:
[:, :, 1] =
 2.59808  2.17945  2.17945  2.59808
 2.17945  1.65831  1.65831  2.17945
 2.17945  1.65831  1.65831  2.17945
 2.59808  2.17945  2.17945  2.59808

[:, :, 2] =
 2.17945  1.65831   1.65831   2.17945
 1.65831  0.866025  0.866025  1.65831
 1.65831  0.866025  0.866025  1.65831
 2.17945  1.65831   1.65831   2.17945

[:, :, 3] =
 2.17945  1.65831   1.65831   2.17945
 1.65831  0.866025  0.866025  1.65831
 1.65831  0.866025  0.866025  1.65831
 2.17945  1.65831   1.65831   2.17945

[:, :, 4] =
 2.59808  2.17945  2.17945  2.59808
 2.17945  1.65831  1.65831  2.17945
 2.17945  1.65831  1.65831  2.17945
 2.59808  2.17945  2.17945  2.59808
```
"""
function distanceToCenter3D(n::Integer, d::Integer)::Array{Float64,3}
    m = n^d
    mid = (m+1)/2
    D = Array{Float64,3}(undef, (m,m,m))
    for i in 1:m
        for j in 1:m
            for k in 1:m
                D[i,j,k] = sqrt( (i-mid)^2+(j-mid)^2+(k-mid)^2 )
            end
        end
    end
    return D
end

"""
    blobInfo3D(P,D)

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
function blobInfo3D(P::BitArray{3}, D::Array{Float64,3})::Tuple{Int64,Int64,Float64,Int64}
    n = size(P)[1]
    xA = Int32[]
    yA = Int32[]
    zA = Int32[]
    mid = Integer(floor(n/2))
    if n%2==0
        if P[mid  , mid  , mid  ]
            push!(xA, mid)
            push!(yA, mid)
            push!(zA, mid)
        end
        if P[mid  , mid  , mid+1]
            push!(xA, mid)
            push!(yA, mid)
            push!(zA, mid+1)
        end
        if P[mid  , mid+1, mid  ]
            push!(xA, mid)
            push!(yA, mid+1)
            push!(zA, mid)
        end
        if P[mid  , mid+1, mid+1]
            push!(xA, mid)
            push!(yA, mid+1)
            push!(zA, mid+1)
        end
        if P[mid+1, mid  , mid  ]
            push!(xA, mid+1)
            push!(yA, mid)
            push!(zA, mid)
        end
        if P[mid+1, mid  , mid+1]
            push!(xA, mid+1)
            push!(yA, mid)
            push!(zA, mid+1)
        end
        if P[mid+1, mid+1, mid  ]
            push!(xA, mid+1)
            push!(yA, mid+1)
            push!(zA, mid)
        end
        if P[mid+1, mid+1, mid+1]
            push!(xA, mid+1)
            push!(yA, mid+1)
            push!(zA, mid+1)
        end
    else
        if P[mid+1, mid+1, mid+1]
            push!(xA, mid+1)
            push!(yA, mid+1)
            push!(zA, mid+1)
        end
    end
    xB = Int32[]
    yB = Int32[]
    zB = Int32[]
    step = 0
    vol = length(xA)
    area = 0
    dist = 0.0
    while length(xA)>0
        xA,yA,zA, xB,yB,zB, vol, area, dist = blobNeighbors3D!(P, n, xA,yA,zA, xB,yB,zB, vol, area, dist, D)
        step+=1
    end
    return vol, area, dist, step
end
function blobNeighbors3D!(P::BitArray{3}, n::Integer, 
    xA::Array{<:Integer,1}, yA::Array{<:Integer,1}, zA::Array{<:Integer,1},
    xB::Array{<:Integer,1}, yB::Array{<:Integer,1}, zB::Array{<:Integer,1},
    vol::Integer, area::Integer, dist::Real, D::Array{Float64,3})::Tuple{Array{<:Integer,1},Array{<:Integer,1},Array{<:Integer,1}, Array{<:Integer,1},Array{<:Integer,1},Array{<:Integer,1}, Int64,Int64,Float64}
    xC = Int32[]
    yC = Int32[]
    zC = Int32[]
    for i in 1:length(xA)
        a = xA[i]
        b = yA[i]
        c = zA[i]
        push!(xB, a)
        push!(yB, b)
        push!(zB, c)
    end
    for i in 1:length(xA)
        a = xA[i]
        b = yA[i]
        c = zA[i]
        if a>1 && P[a-1,b,c] && !isIn(a-1,b,c, xB,yB,zB) && !isIn(a-1,b,c, xC,yC,zC)
            push!(xC, a-1)
            push!(yC, b)
            push!(zC, c)
            vol+=1
            if D[a-1,b,c]>dist
                dist = D[a-1,b,c]
            end
        end
        if a==1 || !P[a-1,b,c]
            area+=1
        end
        if a<n && P[a+1,b,c] && !isIn(a+1,b,c, xB,yB,zB) && !isIn(a+1,b,c, xC,yC,zC)
            push!(xC, a+1)
            push!(yC, b)
            push!(zC, c)
            vol+=1
            if D[a+1,b,c]>dist
                dist = D[a+1,b,c]
            end
        end
        if a==n || !P[a+1,b,c]
            area+=1
        end

        if b>1 && P[a,b-1,c] && !isIn(a,b-1,c, xB,yB,zB) && !isIn(a,b-1,c, xC,yC,zC)
            push!(xC, a)
            push!(yC, b-1)
            push!(zC, c)
            vol+=1
            if D[a,b-1,c]>dist
                dist = D[a,b-1,c]
            end
        end
        if b==1 || !P[a,b-1,c]
            area+=1
        end
        if b<n && P[a,b+1,c] && !isIn(a,b+1,c, xB,yB,zB) && !isIn(a,b+1,c, xC,yC,zC)
            push!(xC, a)
            push!(yC, b+1)
            push!(zC, c)
            vol+=1
            if D[a,b+1,c]>dist
                dist = D[a,b+1,c]
            end
        end
        if b==n || !P[a,b+1,c]
            area+=1
        end

        if c>1 && P[a,b,c-1] && !isIn(a,b,c-1, xB,yB,zB) && !isIn(a,b,c-1, xC,yC,zC)
            push!(xC, a)
            push!(yC, b)
            push!(zC, c-1)
            vol+=1
            if D[a,b,c-1]>dist
                dist = D[a,b,c-1]
            end
        end
        if c==1 || !P[a,b,c-1]
            area+=1
        end
        if c<n && P[a,b,c+1] && !isIn(a,b,c+1, xB,yB,zB) && !isIn(a,b,c+1, xC,yC,zC)
            push!(xC, a)
            push!(yC, b)
            push!(zC, c+1)
            vol+=1
            if D[a,b,c+1]>dist
                dist = D[a,b,c+1]
            end
        end
        if c==n || !P[a,b,c+1]
            area+=1
        end

    end
    xB = vcat(xB,xA)
    yB = vcat(yB,yA)
    zB = vcat(zB,zA)
    return xC,yC,zC, xB,yB,zB, vol, area, dist
end
function isIn(i::Integer,j::Integer,k::Integer, xM::Array{<:Integer,1},yM::Array{<:Integer,1},zM::Array{<:Integer,1})::Bool
    for a in findall(x->x==i, xM)
        if yM[a]==j && zM[a]==k
            return true
        end
    end
    return false
end

"""
    blobData3D(n,p,d, rep)

Calculates the blob data in 3D for a depth d percolation of an n*n grid with probability p, using rep experiments.

# Examples
```julia-repl
julia> blobData3D(2,0.5,2,100)
(1153, 4410, 213.90104033137646, 323)
julia> blobData3D(2,0.6,2,100)
(1996, 6954, 245.22904889408858, 423)
julia> blobData3D(2,0.7,2,100)
(3111, 9594, 259.3889943957486, 459)
julia> blobData3D(2,0.8,2,100)
(4159, 10730, 259.8076211353316, 411)
julia> blobData3D(2,0.9,2,100)
(5143, 10860, 259.8076211353316, 357)
```
"""
function blobData3D(n::Integer,p::Real,d::Integer,rep::Integer)::Tuple{Int64,Int64,Float64,Int64,Int64}
    D = distanceToCenter3D(n,d)
    sq = Threads.Atomic{Int64}(0)
    vol = Threads.Atomic{Int64}(0)
    area = Threads.Atomic{Int64}(0)
    dist = Threads.Atomic{Float64}(0)
    step = Threads.Atomic{Int64}(0)
    Threads.@threads for i in 1:rep
        P = fractalPercolation3D(n,p,d)
        vo, ae, di, st = blobInfo3D(P, D)
        Threads.atomic_add!(vol, vo)
        Threads.atomic_add!(area, ae)
        Threads.atomic_add!(dist, di)
        Threads.atomic_add!(step, st)
        Threads.atomic_add!(sq, sum(P))
    end
    return (vol[], area[], dist[], step[], sq[])
end




function saveSmartBlobData3D(n::Integer, d::Integer, rep::Integer, fileName::String)
    println("n=",n, " d=",d, " rep=",rep)
    f = open(fileName, "a")
    p = 0
    while p<=1
        p += 0.01
        vol, area, dist, step, sq = blobData3D(n,p,d, rep)
        println(f, string(rep)*','*string(n)*','*string(d)*','*string(p)*','*string(sq)*','*string(vol)*','*string(area)*','*string(dist)*','*string(step))
    end
    close(f)
end






rep = 50000
file_name = "blob_3D_"*string(rep)*".csv"
entitleFile(file_name, "rep,n,d,p,sq,vol,area,dist,step")

# # saveSmartBlobData3D(2, 1, rep, file_name)
# # saveSmartBlobData3D(2, 2, rep, file_name)
# # saveSmartBlobData3D(2, 3, rep, file_name)
# # saveSmartBlobData3D(2, 4, rep, file_name)
# # saveSmartBlobData3D(2, 5, rep, file_name)

# saveSmartBlobData3D(3, 1, rep, file_name)
# saveSmartBlobData3D(3, 2, rep, file_name)
# saveSmartBlobData3D(3, 3, rep, file_name)

# saveSmartBlobData3D(5, 1, rep, file_name)
# saveSmartBlobData3D(5, 2, rep, file_name)

# saveSmartBlobData3D(6, 1, rep, file_name)
# saveSmartBlobData3D(7, 1, rep, file_name)
# saveSmartBlobData3D(8, 1, rep, file_name)
# saveSmartBlobData3D(9, 1, rep, file_name)
# saveSmartBlobData3D(10, 1, rep, file_name)
# saveSmartBlobData3D(11, 1, rep, file_name)
# saveSmartBlobData3D(12, 1, rep, file_name)
# saveSmartBlobData3D(13, 1, rep, file_name)
# saveSmartBlobData3D(14, 1, rep, file_name)
# saveSmartBlobData3D(15, 1, rep, file_name)
# saveSmartBlobData3D(20, 1, rep, file_name)
# saveSmartBlobData3D(25, 1, rep, file_name)
# saveSmartBlobData3D(30, 1, rep, file_name)

