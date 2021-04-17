var graph =  document.getElementById("graph");

function activate(e){
    if (e.classList[0]==="n^d"){
        var c = document.getElementsByClassName("n^d");
        for(var j = 0; j < c.length; j++){
            c[j].classList.remove("active");
        }
        e.classList.add("active");
    }
    else{
        document.getElementById("absolute").classList.remove("active");
        document.getElementById("relative").classList.remove("active");
        e.classList.add("active");
    }
    updateGraph();
}

function updateGraph(){
    var path = "https://github.com/pauldubois98/PercolationFractalsStudy/raw/main/data_visualization/intersection_2D/";
    if(document.getElementById("absolute").classList[0]=="active"){
        path += ""
    }
    if(document.getElementById("relative").classList[0]=="active"){
        path += "relative_"
    }
    path += "intersection_2D_n^d=";
    const n_d = ["2^1", "2^2", "2^3", "2^4", "2^5", "2^6", "2^7", "2^8", 
                 "3^1", "3^2", "3^3", "3^4", "3^5", 
                 "5^1", "5^2", "5^3", 
                 "7^1", "7^2", 
                 "11^1", "11^2", 
                 "13^1", "13^2", 
                 "17^1", "17^2", 
                 "20^1", "25^1", "50^1", "75^1", "100^1", 
                 "125^1", "150^1", "175^1", "200^1"]
    for(var i=0; i < n_d.length; i++){
        if(document.getElementById(n_d[i]).classList[1]=="active"){
            path += n_d[i]
        }
    }
    
    path += ".png"
    //console.log(path);
    graph.src = path;
}
