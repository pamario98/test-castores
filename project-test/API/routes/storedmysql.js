var express = require("express");
var router = express.Router();
var mysql = require("mysql");

var conn = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "examen_castores_noticias",
});

conn.connect(function (err) {
  if (err) {
    console.log("ERROR EN BASE DE DATOS" + err);
  } else {
    console.log("CONEXION EXITOSA A BD");
  }
});

router.get('/get_notas',(req,res,next)=>{
  var query="CALL get_notas()";
  conn.query(query,true,(err,results,fields)=>{
      if (err) {
          console.log("ERROR EN CONSULTA: "+err);
          res.send("ERROR EN CONSULTA: "+err);
      }
      else{
          console.log(results);
          res.send(results[0]);
      }
  });

});

router.get('/get_comentarios',(req,res,next)=>{
  var query="CALL get_comentarios()";
  conn.query(query,true,(err,results,fields)=>{
      if (err) {
          console.log("ERROR EN CONSULTA: "+err);
          res.send("ERROR EN CONSULTA: "+err);
      }
      else{
          console.log(results);
          res.send(results[0]);
      }
  });

});

router.get('/get_usuarios',(req,res,next)=>{
  var query="CALL get_usuarios()";
  conn.query(query,true,(err,results,fields)=>{
      if (err) {
          console.log("ERROR EN CONSULTA: "+err);
          res.send("ERROR EN CONSULTA: "+err);
      }
      else{
          console.log(results);
          res.send(results[0]);
      }
  });

});

router.get('/get_personal_interno',(req,res,next)=>{
  var query="CALL get_personal_interno()";
  conn.query(query,true,(err,results,fields)=>{
      if (err) {
          console.log("ERROR EN CONSULTA: "+err);
          res.send("ERROR EN CONSULTA: "+err);
      }
      else{
          console.log(results);
          res.send(results[0]);
      }
  });

});


router.post("/sp_crear_notas", (req, res, next) => {
  //var query = "CALL sp_crear_notas()";
  var query="CALL sp_crear_notas(?,?,?)";

  var datos = [
    Number(req.body._idusuario),
    req.body._descripcion,
    req.body._titulo
  ];
  conn.query(query, datos, (err, results, fields) => {
    if (err) {
      console.log(JSON.stringify("ERROR EN CONSULTA: " + err));
    } else {
      //console.log(JSON.stringify(results[0]));
      res.send(JSON.stringify("NOTA CREADA"));
    }
  });
});


router.post("/sp_crear_usuario", (req, res, next) => {
  //var query = "CALL sp_crear_notas()";
  var query="CALL sp_crear_usuario(?,?,?,?,?,?,?)";

  var datos = [
    req.body._nombre,
    req.body._tipo,
    req.body._correo,
    req.body._password,
    req.body._apepaterno,
    req.body._apematerno,
    req.body._direccion
  ];
  conn.query(query, datos, (err, results, fields) => {
    if (err) {
      console.log(JSON.stringify("ERROR EN CONSULTA: " + err));
    } else {
      //console.log(JSON.stringify(results[0]));
      res.send(JSON.stringify("USUARIO CREADO"));
    }
  });
});

router.post("/sp_comentar_nota", (req, res, next) => {
  var query="CALL sp_comentar_nota(?,?,?)";

  var datos = [
    Number(req.body._idnota),
    Number(req.body._idusuario),
    req.body._comentario
  ];
  conn.query(query, datos, (err, results, fields) => {
    if (err) {
      console.log(JSON.stringify("ERROR EN CONSULTA: " + err));
    } else {
      //console.log(JSON.stringify(results[0]));
      res.send(JSON.stringify("NOTA COMENTADA"));
    }
  });
});

router.post("/sp_comentarios_notas", (req, res, next) => {
  var query="CALL sp_comentarios_notas(?)";

  var datos = [
    Number(req.body._idnota)
  ];
  conn.query(query, datos, (err, results, fields) => {
    if (err) {
      console.log(JSON.stringify("ERROR EN CONSULTA: " + err));
    } else {
      //console.log(JSON.stringify(results[0]));
      res.send(JSON.stringify("OBTUVO NOTA"));
    }
  });
});

router.post("/sp_responder_comentario", (req, res, next) => {
  var query="CALL sp_responder_comentario(?,?,?)";

  var datos = [
    Number(req.body._idcomentario),
    Number(req.body._idusuario),
    req.body._comentario
  ];
  conn.query(query, datos, (err, results, fields) => {
    if (err) {
      console.log(JSON.stringify("ERROR EN CONSULTA: " + err));
    } else {
      //console.log(JSON.stringify(results[0]));
      res.send(JSON.stringify("COMENTARIO RESPONDIDO"));
    }
  });
});

router.post("/sp_respuestas_comentarios_notas", (req, res, next) => {
  var query="CALL sp_respuestas_comentarios_notas(?)";

  var datos = [
    Number(req.body._idcomentario)
  ];
  conn.query(query, datos, (err, results, fields) => {
    if (err) {
      console.log(JSON.stringify("ERROR EN CONSULTA: " + err));
    } else {
      //console.log(JSON.stringify(results[0]));
      res.send(JSON.stringify("RESPUESTA COMENTARIO NOTA"));
    }
  });
});


module.exports = router;
