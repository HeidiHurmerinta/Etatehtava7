<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Asiakkaan tietojen muutos</title>
</head>
<body>
<form id="tiedot">
	<table>
		<thead>
			<tr>
			<th colspan="6" id="ilmo"></th>
			</tr>
			<tr>
				<th>Asiakas Id</th>
				<th>Etunimi</th>
				<th>Sukunimi</th>
				<th>Puhelin</th>
				<th>Sposti</th>			
				<th></th>
			</tr>
		</thead>
			<tr>
				<td><input type="text" name="asiakas_id" id="asiakas_id"></td>
				<td><input type="text" name="etunimi" id="etunimi"></td>
				<td><input type="text" name="sukunimi" id="sukunimi"></td>
				<td><input type="text" name="puhelin" id="puhelin"></td>
				<td><input type="text" name="sposti" id="sposti"></td>			
				<td><input type="button" id="tallenna" value="Hyväksy" onclick="vieTiedot()"></td>
		<tbody>
		</tbody>
	</table>
	<input type="hidden" name="asiakas_id" id="asiakas_id">
</form>
<span id="ilmo"></span>
</body>
<script>
document.getElementById("asiakas_id").focus();//viedään kursori asiakas_id-kenttään sivun latauksen yhteydessä

//Haetaan muutettavan asiakkaan tiedot. Kutsutaan backin GET-metodia ja välitetään kutsun mukana muutettavan tiedon id
//GET /asiakkaat/haeyksi/id
var asiakas_id = requestURLParam("asiakas_id"); //Funktio löytyy scripts/main.js 
fetch("asiakkaat/haeyksi/" + asiakas_id,{//Lähetetään kutsu backendiin
    method: 'GET'	      
  })
.then( function (response) {//Odotetaan vastausta ja muutetaan JSON-vastausteksti objektiksi
	return response.json()
})
.then( function (responseJson) {//Otetaan vastaan objekti responseJson-parametrissä	
	console.log(responseJson);
	document.getElementById("asiakas_id").value = responseJson.asiakas_id;		
	document.getElementById("etunimi").value = responseJson.etunimi;	
	document.getElementById("sukunimi").value = responseJson.sukunimi;	
	document.getElementById("puhelin").value = responseJson.puhelin;	
	document.getElementById("sposti").value = responseJson.sposti;	
	document.getElementById("vanhaid").value = responseJson.asiakas_id;	
});	

//Funktio tietojen muuttamista varten. Kutsutaan backin PUT-metodia ja välitetään kutsun mukana muutetut tiedot json-stringinä.
//PUT /autot/
function vieTiedot(){	
	var ilmo="";
	if(document.getElementById("etunimi").value.length<2){
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
	console.log(formJsonStr);
	//Lähetään muutetut tiedot backendiin
	fetch("asiakkaat",{//Lähetetään kutsu backendiin
	      method: 'PUT',
	      body:formJsonStr
	    })
	.then( function (response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
		return response.json();
	})
	.then( function (responseJson) {//Otetaan vastaan objekti responseJson-parametrissä	
		var vastaus = responseJson.response;		
		if(vastaus==0){
			document.getElementById("ilmo").innerHTML= "Tietojen päivitys epäonnistui";
      }else if(vastaus==1){	        	
      	document.getElementById("ilmo").innerHTML= "Tietojen päivitys onnistui";			      	
		}	
		setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 5000);
	});	
	document.getElementById("tiedot").reset(); //tyhjennetään tiedot -lomake
}
</script>
</html>