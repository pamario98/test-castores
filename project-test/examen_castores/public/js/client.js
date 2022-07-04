var _idusuario = document.getElementById("_idusuario");
var _titulo = document.getElementById("_titulo");
var _descripcion = document.getElementById("_descripcion");




var datos=""

var baseURL="http://localhost:3001/api";


var crear=()=>{

    var noticias={
        _idusuario:_idusuario.value,
        _titulo:_titulo.value,
        _descripcion:_descripcion.value,

    }

    url="http://localhost:3001/api/sp_crear_notas";

    fetch(url,{
    method:"POST",

    body:JSON.stringify(noticias),
      headers:{
          "Content-type":"application/json"
      }

    }).then((response)=>{
        return response.json();
    }).then((data)=>{
        console.log(data);
        
    }).catch((error)=>{
        console.log("ERROR AL SUBIR: "+error);
        console.log(noticias)
    })
}


var traernotas= ()=>{

    $(document).ready(function() {   
        var url = 'http://localhost:3001/api/get_notas';
    
         $('#tablaNoticias').DataTable({            
             "ajax":{
                 "url": url,
                 "dataSrc":""
             },
             "columns":[
                 {"data":"idnota"},
                 {"data":"idusuario"},
                 {"data":"descripcion"},
                 {"data":"titulo"},
                 {"data":"fecha"},
             ],
         });
    });

}

var traercomentario= ()=>{

    $(document).ready(function() {   
        var url = 'http://localhost:3001/api/get_comentarios';
    
         $('#tablaComentarios').DataTable({            
             "ajax":{
                 "url": url,
                 "dataSrc":""
             },
             "columns":[
                 {"data":"idcomentario"},
                 {"data":"comentario"},
                 {"data":"idnota"},
                 {"data":"idusuario"},
                 {"data":"fecha"},
                 {"data":"idcomentariorespuesta"},
             ],
         });
    });

}

