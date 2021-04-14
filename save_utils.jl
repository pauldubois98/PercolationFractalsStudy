print("Threads: ")
println(Threads.nthreads())

function entitleFile(file_name, title)
    try
        local f
        f = open(file_name, "r")
        inside = read(f,1)
        close(f)
        if inside==UInt8[]
            f = open(file_name, "a")
            println(f, title)
            close(f)
        end
    catch e
        local f
        f = open(file_name, "a")
        println(f, title)
        close(f)    
    end
end

function smartSaveCrossingData(crossingDataFunc::Function, n::Integer, d::Integer, rep::Integer, fileName::String)
    println("n=",n, " d=",d, " rep=",rep)
    f = open(fileName, "a")
    p = -0.1
    nc = 0
    while nc==0 && p<=1
        p += 0.1
        lc,nc, sq = crossingDataFunc(n,p,d, rep)
        println(f, string(rep)*','*string(n)*','*string(d)*','*string(p)*','*string(nc)*','*string(lc)*','*string(sq))
    end
    old_p = p
    p -= 0.1
    while nc!=rep && p<=1
        p += 0.01
        if old_p != p
            lc,nc, sq = crossingDataFunc(n,p,d, rep)
            println(f, string(rep)*','*string(n)*','*string(d)*','*string(p)*','*string(nc)*','*string(lc)*','*string(sq))
        end
    end
    while p<0.9
        p += 0.1
        lc,nc, sq = crossingDataFunc(n,p,d, rep)
        println(f, string(rep)*','*string(n)*','*string(d)*','*string(p)*','*string(nc)*','*string(lc)*','*string(sq))
    end
    p=1
    lc,nc, sq = crossingDataFunc(n,p,d, rep)
    println(f, string(rep)*','*string(n)*','*string(d)*','*string(p)*','*string(nc)*','*string(lc)*','*string(sq))
    close(f)
end




