using SparseArrays

"""
    disp(P)

Displays a percolation matrix.
"""
function disp(P::BitArray{2})
    print('+')
    for j in 1:size(P)[2]
        print('-')
    end
    println('+')
    for i in 1:size(P)[1]
        print('|')
        for j in 1:size(P)[2]
            if P[i,j]
                print('*')
            else
                print(' ')
            end

        end
        println('|')
    end
    print('+')
    for j in 1:size(P)[2]
        print('-')
    end
    println('+')
end

############################# Fractal Percolation #############################
"""
    fractalPercolation_(n, p, d)

Returns a depth d percolation of an n*n grid with probability p.

# Example
```julia-repl
julia> fractalPercolation_(2,0.7,3)
8×8 BitArray{2}:
true   true  false  false   true   true  false  false
true  false  false  false  false  false  false  false
false  false  false  false  false  false  false  false
false  false  false  false  false  false  false  false
true   true  false  false  false  false  false  false
true   true  false  false   true   true  false  false
false  false  false  false  false  false  false  false
false  false  false  false  false  false  false  false
```
"""
function fractalPercolation_(n::Integer, p::Real, d::Integer)::BitArray{2}
    if d==0
        return rand(Float32, (n,n)) .< p
    else
        P = rand(Float32, (n,n)) .< p
        return vcat([hcat([x ? fractalPercolation(n, p, d-1) : falses( (n^(d-1),n^(d-1)) ) for x in P[i,:]]...) for i in 1:n]...)
    end
end
"""
    fractalPercolation(n, p, d)

Returns a depth d percolation of an n*n grid with probability p.

# Example
```julia-repl
julia> fractalPercolation(2,0.7,3)
8×8 BitArray{2}:
false  false  false  false   true   true  false  false
false  false  false  false   true  false  false  false
false  false  false  false  false  false  false  false
false  false  false  false  false  false  false  false
true   true  false  false   true   true  false  false
false  false  false  false   true   true  false  false
false  false  false  false  false  false  false  false
false  false  false  false  false  false  false  false
```
"""
function fractalPercolation(n::Integer, p::Real, d::Integer)::BitArray{2}
    P = falses((n^d,n^d))
    fractalFill!(P, 1,1, n, d-1, p)
    return P
end
function fractalFill!(P, i, j, n, d, p)
    if d==0
        P[i:i+n-1, j:j+n-1] = rand(Float32, (n,n)) .< p
    else
        s = n^d #step size
        for a = 0:n-1
            for b in 0:n-1
                if rand()<p
                    fractalFill!(P, i+(a*s), j+(b*s), n, d-1, p)
                end
            end
        end
    end
end

############################# Semi Straight Crossing #############################
"""
    semiStraightCrossingDense(P)

Tells if there is an up/down crossing in the percolation P, with no backtrack, using dense variables.

# Example
```julia-repl
julia> P = percolation(5,0.5)
5×5 BitArray{2}:
 0  1  0  1  1
 1  1  0  0  0
 0  0  1  1  0
 1  1  1  0  1
 1  1  1  1  1
julia> semiStraightCrossingDense(P)
false
```
"""
function semiStraightCrossingDense(P::BitArray{2})::Bool
    n = size(P)[1]
    c = P[1,:]
    for i = 2:n
        c = c .* P[i,:]
        for j = 2:n
            if P[i,j] * !c[j]
                c[j] = c[j-1]
            end
        end
        for j = n-1:-1:1
            if P[i,j] * !c[j]
                c[j] = c[j+1]
            end
        end
    end
    return any(c)
end
"""
    semiStraightCrossingSparse(P)

Tells if there is an up/down crossing in the percolation P, with no backtrack, using sparse variables.

# Example
```julia-repl
julia> P = percolation(5,0.5)
5×5 BitArray{2}:
 0  1  0  1  1
 1  1  0  0  0
 0  0  1  1  0
 1  1  1  0  1
 1  1  1  1  1
julia> semiStraightCrossingSparse(P)
false
```
"""
function semiStraightCrossingSparse(P::BitArray{2})::Bool
    n = size(P)[1]
    c = sparse(P[1,:])
    for i = 2:n
        c = c .* P[i,:]
        for j = 2:n
            if P[i,j] * !c[j]
                c[j] = c[j-1]
            end
        end
        for j = n-1:-1:1
            if P[i,j] * !c[j]
                c[j] = c[j+1]
            end
        end
    end
    return any(c)
end


"""
    semiStraightCrossingLength(P)

Tells the length of the shortest up/down crossing in the percolation P, with no backtrack, if there is one.

# Example
```julia-repl
julia> P = percolation(5,0.5)
5×5 BitArray{2}:
 0  1  0  1  1
 1  1  0  0  0
 0  0  1  1  0
 1  1  1  0  1
 1  1  1  1  1
julia> semiStraightCrossing(P)
0
```
"""
function semiStraightCrossingLength(P::BitArray{2})::Integer
    n = size(P)[1]
    c = Array{Int64,1}(undef, n)
    c[:] = P[1,:]
    for i = 2:n
        a = c .* P[i,:]
        b = a .> 0
        c = a + b
        for j = 2:n
            if P[i,j] * (c[j]==0) * (c[j-1]>0)
                c[j] = c[j-1] + 1
            end
        end
        for j = n-1:-1:1
            if P[i,j] * (c[j]==0) * (c[j+1]>0)
                c[j] = c[j+1] + 1
            end
        end
    end
    c = sparse(c).nzval
    if length(c)==0
        return 0
    else
        return minimum(c)
    end
end

############################# Neighbors #############################
function neighborsDense(P::BitArray{2}, n::Integer, A::BitArray{2}, B::BitArray{2})
    for i in 2:n-1
        for j in 2:n-1
            if P[i,j] && (A[i-1,j] || A[i+1,j] || A[i,j-1] || A[i,j+1])
                B[i,j] = true
                P[i,j] = false
            else
                B[i,j] = false
            end
        end
    end
    for i in 2:n-1
        j=1
        if P[i,j] && (A[i-1,j] || A[i+1,j] || A[i,j+1])
            B[i,j] = true
            P[i,j] = false
        else
            B[i,j] = false
        end
        j=n
        if P[i,j] && (A[i-1,j] || A[i+1,j] || A[i,j-1])
            B[i,j] = true
            P[i,j] = false
        else
            B[i,j] = false
        end
    end
    for j in 2:n-1
        i=1
        if P[i,j] && (A[i+1,j] || A[i,j-1] || A[i,j+1])
            B[i,j] = true
            P[i,j] = false
        else
            B[i,j] = false
        end
        i=n
        if P[i,j] && (A[i-1,j] || A[i,j-1] || A[i,j+1])
            B[i,j] = true
            P[i,j] = false
        else
            B[i,j] = false
        end
    end
    if P[1,1] && (A[1,2] || A[2,1])
        B[1,1] = true
        P[1,1] = false
    else
        B[1,1] = false
    end
    if P[n,1] && (A[n,2] || A[n-1,1])
        B[n,1] = true
        P[n,1] = false
    else
        B[n,1] = false
    end
    if P[1,n] && (A[1,n-1] || A[2,n])
        B[1,n] = true
        P[1,n] = false
    else
        B[1,n] = false
    end
    if P[n,n] && (A[n,n-1] || A[n-1,n])
        B[n,n] = true
        P[n,n] = false
    else
        B[n,n] = false
    end
end
function neighborsSparse(P::BitArray{2}, n::Integer, A::SparseMatrixCSC{Bool,Int64})::SparseMatrixCSC{Bool,Int64}
    I,J,V = findnz(A)
    B = spzeros(Bool, n,n)
    for k in 1:length(V)
        i = I[k]
        j = J[k]
        P[i,j] = false
        if i>1 && P[i-1,j]
            B[i-1,j] = true
        end
        if i<n && P[i+1,j]
            B[i+1,j] = true
        end
        if j>1 && P[i,j-1]
            B[i,j-1] = true
        end
        if j<n && P[i,j+1]
            B[i,j+1] = true
        end
    end
    return B
end

############################# Crossing #############################
"""
    crossingDense(P)

Tells if there is an up/down crossing in the percolation P, using dense variables.

# Example
```julia-repl
julia> P = percolation(5,0.5)
5×5 BitArray{2}:
 0  1  0  1  1
 1  1  0  0  0
 0  0  1  1  0
 1  1  1  0  1
 1  1  1  1  1
julia> crossingDense(P)
false
```
"""
function crossingDense(P::BitArray{2})::Integer
    n = size(P)[1]
    A = falses(n,n)
    A[1,:] = P[1,:]
    B = falses(n,n)
    B[1,1] = true
    c = 1
    while !any(A[n,:]) && any(A) && !any(B[n,:]) && any(B)
        neighborsDense(P, n, A, B)
        neighborsDense(P, n, B, A)
        c+=2
    end
    if any(B[n,:])
        return c-1
    elseif any(A[n,:])
        return c
    else
        return 0
    end
end
"""
    crossingSparse(P)

Tells if there is an up/down crossing in the percolation P, using sparse variables.

# Example
```julia-repl
julia> P = percolation(5,0.5)
5×5 BitArray{2}:
 0  1  0  1  1
 1  1  0  0  0
 0  0  1  1  0
 1  1  1  0  1
 1  1  1  1  1
julia> crossingSparse(P)
false
```
"""
function crossingSparse(P::BitArray{2})::Integer
    n = size(P)[1]
    A = spzeros(Bool, n,n)
    A[1,:] = P[1,:]
    c = 1
    while !any(A[n,:]) && any(A)
        A = neighborsSparse(P, n, A)
        c+=1
    end
    if any(A[n,:])
        return c
    else
        return 0
    end
end

############################# Tests #############################



if isinteractive()
    P = falses(8,8)
    P[1,1:5] = trues(5)
    P[1:5,1] = trues(5)
    P[5,1:4] = trues(4)
    P[3:5,4] = trues(3)
    P[3,4:7] = trues(4)
    P[3:8,7] = trues(6)
    disp(P)
    println(semiStraightCrossingDense(P))
    println(semiStraightCrossingSparse(P))
    println(semiStraightCrossingLength(P))
    A = copy(P)
    println(crossingDense(A))
    A = copy(P)
    println(crossingSparse(A))

    P = falses(8,8)
    P[1,1:5] = trues(5)
    P[1:5,1] = trues(5)
    P[5,1:4] = trues(4)
    P[3:5,4] = trues(3)
    P[3,4:7] = trues(4)
    P[3:8,5] = trues(6)
    disp(P)
    println(semiStraightCrossingDense(P))
    println(semiStraightCrossingSparse(P))
    println(semiStraightCrossingLength(P))
    A = copy(P)
    println(crossingDense(A))
    A = copy(P)
    println(crossingSparse(A))

    n=2
    p=0.9
    d=8
    println("Fractal Percolation Method 1")
    @time P = fractalPercolation_(n,p,d)
    println("Fractal Percolation Method 2")
    @time P = fractalPercolation(n,p,d)

    println("Semi Straight Crossing Dense")
    @time semiStraightCrossingDense(A)
    println("Semi Straight Crossing Sparse")
    @time semiStraightCrossingSparse(A)
    println("Semi Straight Crossing Length")
    @time semiStraightCrossingLength(A)
    A = copy(P)
    println("Crossing Dense")
    @time crossingDense(A)
    A = copy(P)
    println("Crossing Sparse")
    @time crossingSparse(A)


    # heatmap(fractalPercolation(3,0.8,5), c=:greys, legend=:none, size = (600, 600))
    # savefig("3^5_0.8.png")
    # heatmap(fractalPercolation(5,0.8,3), c=:greys, legend=:none, size = (600, 600))
    # savefig("5^3_0.8.png")
    # heatmap(fractalPercolation(2,0.9,8), c=:greys, legend=:none, size = (600, 600))
    # savefig("2^8_0.9.png")


end
