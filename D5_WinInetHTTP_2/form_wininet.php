<html>

<head></head>

<body>
   <table border=1>
      <tr>
         <td><h4>Nombre:</h4></td>
         <td><?echo $nombre;?></td>
      </tr>
      <tr>
         <td><h4>Pa&iacute;s:</h4></td>
         <td><?echo $pais;?></td>
      </tr>
      <tr>
         <td valign=top><h4>Comentarios:</h4></td>
         <td><?echo nl2br($comentario);?></td>
      </tr>
   </table>
</body>

</html>