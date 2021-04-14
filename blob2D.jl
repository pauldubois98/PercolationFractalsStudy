include("save_utils.jl")
include("fractal_percolation2D.jl")

"""
    distanceToCenter2D(n,d)

Calculates the distance to center for each square of a n^d*n^d grid.

# Examples
```julia-repl
julia> distanceToCenter2D(5,1)
5×5 Array{Float64,2}:
 2.82843  2.23607  2.0  2.23607  2.82843
 2.23607  1.41421  1.0  1.41421  2.23607
 2.0      1.0      0.0  1.0      2.0
 2.23607  1.41421  1.0  1.41421  2.23607
 2.82843  2.23607  2.0  2.23607  2.82843

julia> distanceToCenter2D(2,2)
4×4 Array{Float64,2}:
 2.12132  1.58114   1.58114   2.12132
 1.58114  0.707107  0.707107  1.58114
 1.58114  0.707107  0.707107  1.58114
 2.12132  1.58114   1.58114   2.12132
```
"""
function distanceToCenter2D(n::Integer, d::Integer)::Array{Float64,2}
    m = n^d
    mid = (m+1)/2
    D = Array{Float64,2}(undef, (m,m))
    for i in 1:m
        for j in 1:m
            D[i,j] = sqrt( (i-mid)^2+(j-mid)^2 )
        end
    end
    return D
end

"""
    blobInfo2D(P,D)

Tells if there is an up/down crossing in the percolation P, using sparse variables.

# Example
```julia-repl
julia> D = distanceToCenter2D(2,3)
8×8 Array{Float64,2}:
 4.94975  4.30116  3.80789  3.53553   3.53553   3.80789  4.30116  4.94975
 4.30116  3.53553  2.91548  2.54951   2.54951   2.91548  3.53553  4.30116
 3.80789  2.91548  2.12132  1.58114   1.58114   2.12132  2.91548  3.80789
 3.53553  2.54951  1.58114  0.707107  0.707107  1.58114  2.54951  3.53553
 3.53553  2.54951  1.58114  0.707107  0.707107  1.58114  2.54951  3.53553
 3.80789  2.91548  2.12132  1.58114   1.58114   2.12132  2.91548  3.80789
 4.30116  3.53553  2.91548  2.54951   2.54951   2.91548  3.53553  4.30116
 4.94975  4.30116  3.80789  3.53553   3.53553   3.80789  4.30116  4.94975

julia> P = fractalPercolation2D(2,0.8,3)
8×8 BitArray{2}:
 1  1  1  1  1  0  0  0
 1  1  1  1  1  1  0  0
 0  1  1  0  0  0  1  1
 1  0  1  1  1  1  1  1
 1  1  1  1  0  1  0  1
 1  0  1  1  1  1  1  1
 1  1  1  0  1  1  1  0
 0  1  1  1  1  0  1  1

julia> blobInfo2D(P,D)
(36, 56, 2.9154759474226504, 3, 32)
```
"""
function blobInfo2D(P::BitArray{2}, D::Array{Float64,2})::Tuple{Int64,Int64,Float64,Int64}
    n = size(P)[1]
    A = spzeros(Bool, n,n)
    mid = Integer(floor(n/2))
    if n%2==0
        A[mid  , mid  ] = P[mid  , mid  ]
        A[mid  , mid+1] = P[mid  , mid+1]
        A[mid+1, mid  ] = P[mid+1, mid  ]
        A[mid+1, mid+1] = P[mid+1, mid+1]
    else
        A[mid+1, mid+1] = P[mid+1, mid+1]
    end
    B = spzeros(Bool, n,n)
    step = 0
    vol = sum(A)
    area = 0
    dist = 0.0
    while any(A)
        A, B, vol, area, dist = blobNeighbors2D!(P, n, A, B, vol, area, dist, D)
        step += 1
    end
    return vol, area, dist, step
end
function blobNeighbors2D!(P::BitArray{2}, n::Integer, A::SparseMatrixCSC{Bool,Int64}, B::SparseMatrixCSC{Bool,Int64}, vol::Integer, area::Integer, dist::Real, D::Array{Float64,2})::Tuple{SparseMatrixCSC{Bool,Int64},SparseMatrixCSC{Bool,Int64},Int64,Int64,Float64}
    I,J,V = findnz(A)
    C = spzeros(Bool, n,n)
    B = B .| A
    for k in 1:length(V)
        i = I[k]
        j = J[k]
        #left
        if i>1 && P[i-1,j] && !B[i-1,j] && !C[i-1,j]
            C[i-1,j] = true
            vol+=1
            if D[i-1,j]>dist
                dist = D[i-1,j]
            end
        end
        if i==1 || !P[i-1,j]
            area+=1
        end
        #right
        if i<n && P[i+1,j] && !B[i+1,j] && !C[i+1,j]
            C[i+1,j] = true
            vol+=1
            if D[i+1,j]>dist
                dist = D[i+1,j]
            end
        end
        if i==n || !P[i+1,j]
            area+=1
        end
        #up
        if j>1 && P[i,j-1] && !B[i,j-1] && !C[i,j-1]
            C[i,j-1] = true
            vol+=1
            if D[i,j-1]>dist
                dist = D[i,j-1]
            end
        end
        if j==1 || !P[i,j-1]
            area+=1
        end
        #down
        if j<n && P[i,j+1] && !B[i,j+1] && !C[i,j+1]
            C[i,j+1] = true
            vol+=1
            if D[i,j+1]>dist
                dist = D[i,j+1]
            end
        end
        if j==n || !P[i,j+1]
            area+=1
        end
    end
    return C, B, vol, area, dist
end


"""
    blobData(n,p,d, rep)

Calculates the blob data in 2D for a depth d percolation of an n*n grid with probability p, using rep experiments.

# Examples
```julia-repl
julia> blobData(2,0.50,8,100)
(24, 48, 13.97458993468934, 20)
julia> blobData(2,0.60,8,100)
(64, 114, 29.416100247364316, 39)
julia> blobData(2,0.70,8,100)
(690, 1048, 174.8642011343014, 284)
julia> blobData(2,0.80,8,100)
(12918, 14616, 1209.332885972414, 1976)
julia> blobData(2,0.90,8,100)
(2758137, 1706670, 15758.792010811241, 29240)
```
"""
function blobData(n::Integer,p::Real,d::Integer,rep::Integer)::Tuple{Int64,Int64,Float64,Int64,Int64}
    D = distanceToCenter2D(n,d)
    sq = Threads.Atomic{Int64}(0)
    vol = Threads.Atomic{Int64}(0)
    area = Threads.Atomic{Int64}(0)
    dist = Threads.Atomic{Float64}(0)
    step = Threads.Atomic{Int64}(0)
    Threads.@threads for i in 1:rep
        P = fractalPercolation2D(n,p,d)
        vo, ae, di, st = blobInfo2D(P, D)
        Threads.atomic_add!(vol, vo)
        Threads.atomic_add!(area, ae)
        Threads.atomic_add!(dist, di)
        Threads.atomic_add!(step, st)
        Threads.atomic_add!(sq, sum(P))
    end
    return (vol[], area[], dist[], step[], sq[])
end



function saveSmartBlobData(n::Integer, d::Integer, rep::Integer, fileName::String)
    println("n=",n, " d=",d, " rep=",rep)
    f = open(fileName, "a")
    p = 0
    while p<=1
        p += 0.01
        vol, area, dist, step, sq = blobData(n,p,d, rep)
        println(f, string(rep)*','*string(n)*','*string(d)*','*string(p)*','*string(sq)*','*string(vol)*','*string(area)*','*string(dist)*','*string(step))
    end
    close(f)
end





rep = 50000
file_name = "blob_2D_"*string(rep)*".csv"
entitleFile(file_name, "rep,n,d,p,sq,vol,area,dist,step")


# # saveSmartBlobData(2, 1, rep, file_name)
# # saveSmartBlobData(2, 2, rep, file_name)
# # saveSmartBlobData(2, 3, rep, file_name)
# # saveSmartBlobData(2, 4, rep, file_name)
# # saveSmartBlobData(2, 5, rep, file_name)
# # saveSmartBlobData(2, 6, rep, file_name)
# # saveSmartBlobData(2, 7, rep, file_name)
# # saveSmartBlobData(2, 8, rep, file_name)

# saveSmartBlobData(3, 1, rep, file_name)
# saveSmartBlobData(3, 2, rep, file_name)
# saveSmartBlobData(3, 3, rep, file_name)
# saveSmartBlobData(3, 4, rep, file_name)
# saveSmartBlobData(3, 5, rep, file_name)

# saveSmartBlobData(5, 1, rep, file_name)
# saveSmartBlobData(5, 2, rep, file_name)
# saveSmartBlobData(5, 3, rep, file_name)

# saveSmartBlobData(7, 1, rep, file_name)
# saveSmartBlobData(7, 2, rep, file_name)

# saveSmartBlobData(11, 1, rep, file_name)
# saveSmartBlobData(11, 2, rep, file_name)

# saveSmartBlobData(13, 1, rep, file_name)
# saveSmartBlobData(13, 2, rep, file_name)

# saveSmartBlobData(17, 1, rep, file_name)
# saveSmartBlobData(17, 2, rep, file_name)

# saveSmartBlobData(25, 1, rep, file_name)
# saveSmartBlobData(51, 1, rep, file_name)
# saveSmartBlobData(75, 1, rep, file_name)
# saveSmartBlobData(101, 1, rep, file_name)
# saveSmartBlobData(125, 1, rep, file_name)
# saveSmartBlobData(151, 1, rep, file_name)
# saveSmartBlobData(175, 1, rep, file_name)
# saveSmartBlobData(201, 1, rep, file_name)

saveSmartBlobData(7*7, 1, rep, file_name)
saveSmartBlobData(11*11, 1, rep, file_name)
saveSmartBlobData(13*13, 1, rep, file_name)
saveSmartBlobData(17*17, 1, rep, file_name)

