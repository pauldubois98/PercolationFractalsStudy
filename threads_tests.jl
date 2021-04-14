using Plots
using SparseArrays
using Base.Threads



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





@everywhere function crossing(P::BitArray{2})::Integer
    n = size(P)[1]
    A = spzeros(Bool, n,n)
    A[1,:] = P[1,:]
    c = 1
    while !any(A[n,:]) && any(A)
        A = neighbors!(P, n, A)
        c+=1
    end
    if any(A[n,:])
        return c
    else
        return 0
    end
end
function neighbors!(P::BitArray{2}, n::Integer, A::SparseMatrixCSC{Bool,Int64})::SparseMatrixCSC{Bool,Int64}
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

"""
    crossingProbability(n,p,d, rep)

    > crossingProbabilityDistributed(n,p,d, rep)
    > crossingProbabilityNonDistributed(n,p,d, rep)

Calculates an approximate probability to have an up/down crossing 
in a depth d percolation of an n*n grid with probability p, using rep experiments.

# Examples
```julia-repl
julia> crossingProbability(2,0.8,8, 100)
0.0
julia> crossingProbability(2,0.85,8, 100)
0.02
julia> crossingProbability(2,0.9,8, 100)
0.82
julia> crossingProbability(2,0.95,8, 100)
0.97
```
"""
function crossingProbabilityDistributed(n::Integer,p::Real,d::Integer,rep::Integer)::Real
    acc = Atomic{Int64}(0)
    @threads for i in 1:rep
        if crossing(fractalPercolation(n,p,d))!=0
            atomic_add!(acc, 1)
        end
    end
    return acc[]/rep
end
function crossingProbabilityNonDistributed(n::Integer,p::Real,d::Integer,rep::Integer)::Real
    c = 0
    for i in 1:rep
        if crossing(fractalPercolation(n,p,d))!=0
            c += 1
        end
    end
    return c/rep
end



"""
    crossingLength(n,p,d, rep)

    > crossingLengthDistributed(n,p,d, rep)
    > crossingLengthNonDistributed(n,p,d, rep)

Calculates an approximate length of an up/down crossing (when existing)
in a depth d percolation of an n*n grid with probability p, using rep experiments.

# Examples
```julia-repl
julia> crossingLength(2,0.8,8, 100)
NaN
julia> crossingLength(2,0.85,8, 100)
430.0
julia> crossingLength(2,0.9,8, 100)
323.25
julia> crossingLength(2,0.95,8, 100)
272.44
```
"""
function crossingLengthDistributed(n::Integer,p::Real,d::Integer,rep::Integer)::Real
    nc = Atomic{Int64}(0)
    lc = Atomic{Int64}(0)
    @threads for i in 1:rep
        l = crossing(fractalPercolation(n,p,d))
        if l!=0
            atomic_add!(nc, 1)
            atomic_add!(lc, l)
        end
    end
    return lc[]/nc[]
end
function crossingLengthNonDistributed(n::Integer,p::Real,d::Integer,rep::Integer)::Real
    nc = 0
    lc = 0
    for i in 1:rep
        l = crossing(fractalPercolation(n,p,d))
        if l!=0
            nc += 1
            lc += l
        end
    end
    return lc/nc
end



"""
    crossingData(n,p,d, rep)

    > crossingDataDistributed(n,p,d, rep)
    > crossingDataNonDistributed(n,p,d, rep)

    Calculates an approximate length of an up/down crossing (when existing)
in a depth d percolation of an n*n grid with probability p, using rep experiments.

# Examples
```julia-repl
julia> crossingData(2,0.8,8, 100)
NaN
julia> crossingData(2,0.85,8, 100)
430.0
julia> crossingData(2,0.9,8, 100)
323.25
julia> crossingData(2,0.95,8, 100)
272.44
```
"""
function crossingData(n::Integer,p::Real,d::Integer,rep::Integer)::Tuple{Int64,Int64}
    nc = Atomic{Int64}(0)
    lc = Atomic{Int64}(0)
    d = Atomic{Int64}(0)
    @threads for i in 1:rep
        P = fractalPercolation(n,p,d)
        l = crossing(P)
        if l!=0
            atomic_add!(nc, 1)
            atomic_add!(lc, l)
            atomic_add!(d, sum(P))
        end
    end
    return (lc[], nc[], d[])
end
function crossingDataNonDistributed(n::Integer,p::Real,d::Integer,rep::Integer)::Tuple{Int64,Int64}
    nc = 0
    lc = 0
    d = 0
    for i in 1:rep
        P = fractalPercolation(n,p,d)
        l = crossing(P)
        if l!=0
            nc += 1
            lc += l
            d += sum(P)
        end
    end
    return (lc, nc, d)
end



if isinteractive()
    println("Probability Non Distributed:")
    @time crossingProbabilityNonDistributed(2,0.8,6,1000)
    println("Probability Distributed:")
    @time crossingProbabilityDistributed(2,0.8,6,1000)

    println("Length Non Distributed:")
    @time crossingLengthNonDistributed(2,0.8,6,1000)
    println("Length Distributed:")
    @time crossingLengthDistributed(2,0.8,6,1000)

    println("Data Non Distributed:")
    @time crossingDataNonDistributed(2,0.8,6,1000)
    println("Data Distributed:")
    @time crossingDataDistributed(2,0.8,6,1000)

    print("Number of threads: ")
    Threads.nthreads()

end

