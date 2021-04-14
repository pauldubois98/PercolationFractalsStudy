using SparseArrays

"""
    fractalPercolation2D(n, p, d)

Returns a depth d percolation of an n*n grid with probability p.

# Example
```julia-repl
julia> fractalPercolation2D(2,0.7,3)
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
function fractalPercolation2D(n::Integer, p::Real, d::Integer)::BitArray{2}
    P = falses((n^d,n^d))
    fractalFill2D!(P, 1,1, n, d-1, p)
    return P
end
function fractalFill2D!(P, i, j, n, d, p)
    if d==0
        P[i:i+n-1, j:j+n-1] = rand(Float32, (n,n)) .< p
    else
        s = n^d #step size
        for a = 0:n-1
            for b in 0:n-1
                if rand()<p
                    fractalFill2D!(P, i+(a*s), j+(b*s), n, d-1, p)
                end
            end
        end
    end
end
