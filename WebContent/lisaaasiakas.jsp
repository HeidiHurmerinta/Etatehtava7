<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Asiakkaan lisääminen</title>
</head>
<body>
<form id="tiedot">
	<table>
	<thead>
		<tr>
			<th colspan="5" id="ilmo"></tr>
			<th colspan="5" class="oikealle"><a href="listaaasiakkaat.jsp" id="takaisin">Takaisin listaukseen</a></th>
			
		<tr>
			<th>Etunimi</th>
			<th>Sukunimi</th>
			<th>Puhelin</th>
			<th>Sposti</th>
			<th></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td><input type="text" name="etunimi" id="etunimi"></td>
			<td><input type="text" name="sukunimi" id="sukunimi"></td>
			<td><input type="text" name="puhelin" id="puhelin"></td>
			<td><input type="text" name="sposti" id="sposti"></td> 
			<td><input type="button" name="nappi" id="tallenna" value="Lisää" onclick="lisaaTiedot()"></td>
		
		</tr>
	</tbody>
</table>
</form>
<span id="ilmo"></span>
<script>

document.getElementById("asiakas_id").focus();
//funktio tietojen lisäämistä varten. Kutsutaan backin POST-metodia ja välitetään kutsun mukana uudet tiedot json-stringinä.
//POST /autot/
function lisaaTiedot(){	
	var ilmo="";
	var d = new Date();
	if(document.getElementById("asiakas_id").value.length<3){
		ilmo="Asiakas id ei kelpaa!";		
	}else if(document.getElementById("etunimi").value.length<2){
		ilmo="Nimi ei kelpaa!";		
	}else if(document.getElementById("sukunimi").value.length<2){
		ilmo="Sukunimi ei kelpaa!";	
	}else if(document.getElementById("puhelin").value.length<5){
		ilmo="Puhelin ei kelpaa!";		
	}else if(document.getElementById("sposti").value.length<5){
		ilmo="Sähköposti ei kelpaa!";		
	}
	if(ilmo!=""){
		document.getElementById("ilmo").innerHTML=ilmo;
		setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 3000);
		return;
	}
	document.getElementById("asiakas_id").value=siivoa(document.getElementById("asiakas_id").value);
	document.getElementById("etunimi").value=siivoa(document.getElementById("etunimi").value);
	document.getElementById("sukunimi").value=siivoa(document.getElementById("sukunimi").value);
	document.getElementById("puhelin").value=siivoa(document.getElementById("puhelin").value);
	document.getElementById("sposti").value=siivoa(document.getElementById("sposti").value);	
		
	var formJsonStr=formDataToJSON(document.getElementById("tiedot")); //muutetaan lomakkeen tiedot json-stringiksi
	//Lähetään uudet tiedot backendiin
	fetch("asiakkaat",{//Lähetetään kutsu backendiin
	      method: 'POST',
	      body:formJsonStr
	    })
	.then( function (response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi		
		return response.json()
	})
	.then( function (responseJson) {//Otetaan vastaan objekti responseJson-parametrissä	
		var vastaus = responseJson.response;		
		if(vastaus==0){
			document.getElementById("ilmo").innerHTML= "Asiakkaan lisääminen epäonnistui";
    	}else if(vastaus==1){	        	
    		document.getElementById("ilmo").innerHTML= "Asiakkaan lisääminen onnistui";			      	
		}
		setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 5000);
	});	
	document.getElementById("tiedot").reset(); //tyhjennetään tiedot -lomake	
}
</script>
</html>