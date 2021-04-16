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
    var path = "../data_visualization/"
    if(document.getElementById("2D").classList[0]=="active"){
        path += "crossing_2D/"
    }
    if(document.getElementById("3D").classList[0]=="active"){
        path += "crossing_3D/"
    }
    if(document.getElementById("straight").classList[0]=="active"){
        path += "straight_"
    }
    if(document.getElementById("semi-straight").classList[0]=="active"){
        path += "semi_straight_"
    }
    if(document.getElementById("non-straight").classList[0]=="active"){
        path += ""
    }
    path += "crossing_"
    if(document.getElementById("probability").classList[0]=="active"){
        path += "proba_"
    }
    if(document.getElementById("length").classList[0]=="active"){
        path += "length_"
    }
    if(document.getElementById("2D").classList[0]=="active"){
        path += "2D"
        if(document.getElementById("d").classList[0]=="active"){
            path += ""
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




