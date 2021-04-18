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
    var path = "https://github.com/pauldubois98/PercolationFractalsStudy/raw/main/data_visualization/";
    if(document.getElementById("2D").classList[0]=="active"){
        path += "blob_2D/"
    }
    if(document.getElementById("3D").classList[0]=="active"){
        path += "blob_3D/"
    }
    path += "blob_";
    if(document.getElementById("step").classList[0]=="active"){
        path += "step_"
    }
    if(document.getElementById("distance").classList[0]=="active"){
        path += "dist_"
    }
    if(document.getElementById("area").classList[0]=="active"){
        path += "area_"
    }
    if(document.getElementById("volume").classList[0]=="active"){
        path += "vol_"
    }
    if(document.getElementById("2D").classList[0]=="active"){
        path += "2D"
        if(document.getElementById("d").classList[0]=="active"){
            path += ""
        }
        if(document.getElementById("nd").classList[0]=="active"){
            path += "_bis"
        }
        if(document.getElementById("n").classList[0]=="active"){
            path += "_ter"
        }
    }
    if(document.getElementById("3D").classList[0]=="active"){
        path += "3D"
        if(document.getElementById("d").classList[0]=="active"){
            path += ""
        }
        if(document.getElementById("n").classList[0]=="active"){
            path += "_bis"
        }
    }
    path += ".png"
    //console.log(path);
    graph.src = path;
}
