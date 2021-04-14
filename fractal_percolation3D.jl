using SparseArrays

"""
fractalPercolation3D(n, p, d)

Returns a depth d percolation of an n*n grid with probability p.

# Example
```julia-repl
julia> fractalPercolation(2,0.5,1)
2×2×2 BitArray{3}:
[:, :, 1] =
false   true
true  false

[:, :, 2] =
true  false
true  false
```
"""
function fractalPercolation3D(n::Integer, p::Real, d::Integer)::BitArray{3}
P = falses((n^d,n^d,n^d))
fractalFill3D!(P, 1,1,1, n, d-1, p)
return P
end
function fractalFill3D!(P, i,j,k, n, d, p)
A = rand(Float32, (n,n,n)) .< p
if d==0
    P[i:i+n-1, j:j+n-1, k:k+n-1] = rand(Float32, (n,n,n)) .< p
else
    s = n^d #step size
    for a = 0:n-1
        for b in 0:n-1
            for c in 0:n-1
                if rand()<p
                    fractalFill3D!(P, i+(a*s), j+(b*s), k+(c*s), n, d-1, p)
                end
            end
        end
    end
end
end

