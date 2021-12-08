function loadXMLDoc(filename) {
  if (window.ActiveXObject) {
    xhttp = new ActiveXObject("Msxml2.XMLHTTP");
  }
  else {
    xhttp = new XMLHttpRequest();
  }
  xhttp.open("GET", filename, false);
  try {xhttp.responseType = "msxml-document"} catch(err) {} // Helping IE11
  xhttp.send("");
  return xhttp.responseXML;
}

function displayResult(xmlFile, xslFile) {
  xml = loadXMLDoc(xmlFile);
  xsl = loadXMLDoc(xslFile);
  // code for IE
  if (window.ActiveXObject || xhttp.responseType == "msxml-document") {
    ex = xml.transformNode(xsl);
    document.getElementById("ndiffResult").innerHTML = ex;
  }
  // code for Chrome, Firefox, Opera, etc.
  else if (document.implementation && document.implementation.createDocument) {
    xsltProcessor = new XSLTProcessor();
    xsltProcessor.importStylesheet(xsl);
    resultDocument = xsltProcessor.transformToFragment(xml, document);
    document.getElementById("ndiffResult").appendChild(resultDocument);
  }
}

