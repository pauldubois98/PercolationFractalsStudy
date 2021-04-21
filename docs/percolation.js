var graph =  document.getElementById("graph");

function activate(e){
    var c = e.parentElement.childNodes;
    var j;
    for(j = 1; j<c.length; j+=2){
        c[j].classList.remove("active");
    }
    e.classList.add("active");
    updateGraph();
}

function updateGraph(){
    var path = "https://github.com/pauldubois98/PercolationFractalsStudy/raw/main/data_visualization/percolation/";

    if(document.getElementById("dimension").classList[0]=="active"){
        path += "dimension"
    }
    if(document.getElementById("density").classList[0]=="active"){
        path += "density"
    }
    if(document.getElementById("complement_density").classList[0]=="active"){
        path += "complement_density"
    }

    if(document.getElementById("1D").classList[0]=="active"){
        path += "_1D"
    }
    if(document.getElementById("2D").classList[0]=="active"){
        path += "_2D"
    }
    if(document.getElementById("3D").classList[0]=="active"){
        path += "_3D"
    }
    if(document.getElementById("4D").classList[0]=="active"){
        path += "_4D"
    }
    if(document.getElementById("5D").classList[0]=="active"){
        path += "_5D"
    }
    
    path += ".png"
    //console.log(path);
    graph.src = path;
}




