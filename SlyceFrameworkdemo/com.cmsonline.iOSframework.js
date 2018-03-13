
function initFramework()
{
    //EMVIO.initframework("JHjBXXjnC0FIHTTmweKrVsA797FPlJLj");
    EMVIO.initframework("phQP9iBIEgl4nEFi8vQmFf25q6m8PieC"); //credit call
}

function processSale(transDict)
{
	EMVIO.processsale(transDict);
}
function processAuthorization(transDict)
{
	EMVIO.processauthorize(transDict);
}
function processCapture(transDict)
{
	EMVIO.processcapture(transDict);
}

function processReturn(transDict)
{
	EMVIO.processreturn(transDict);
}
function phoneReferral(result,authcode)
{
	EMVIO.phonereferral(result,authcode);
}

function confirmCardinfoResult(result)
{
	EMVIO.confirmcardinforesult(result);
}
function getPinpads()
{
	EMVIO.getpinpads();
}
function selectPinpad(name)
{
	EMVIO.selectpinpad(name);
}
function connectPinpad()
{
	EMVIO.connectpinpad();
}
function TMSupdate()
{
	EMVIO.tmsupdate();
}
function signatureVerified(result)
{
	EMVIO.signatureverified(result);
}



/*
delgate functions please implement them as need
*/
function OninitCompleted(arg){
	 document.getElementById('result').innerHTML=arg;
	
    //alert(arg);
 } 
function OnPinpadattached(arg)
{
    content = document.getElementById('result').innerHTML
    document.getElementById('result').innerHTML=content +"<br/>OnPinpadattached";
}
function OntransactionMessageUpdate(msg)
{
	content = document.getElementById('result').innerHTML
	 document.getElementById('result').innerHTML= content +"<br/>"+msg;
}
function OnconfirmCardinfo(cardinfo)
{
	content = document.getElementById('result').innerHTML
	 document.getElementById('result').innerHTML= content +"<br/> cardinfo:"+cardinfo;
	confirmCardinfoResult('true');
}
function OntransactionSaleCompleted(result)
{
	content = document.getElementById('result').innerHTML
	 document.getElementById('result').innerHTML= content +"<br/>"+result;
}

function OnpinPadConnectionCompleted(result)
{
	content = document.getElementById('result').innerHTML
	 document.getElementById('result').innerHTML= content +"<br/> connection completed:"+result;
}
function OnverifySignature(verify)
{
	content = document.getElementById('result').innerHTML
	 document.getElementById('result').innerHTML= content +"<br/>verifySignature:"+verify+"<br/> ";
	signatureVerified("true");
}
function OnvoiceRefferal(verify,phone)
{
	content = document.getElementById('replaceme').innerHTML
	 document.getElementById('replaceme').innerHTML= content +"<br/>OnvoiceRefferal:"+verify+phone+"<br/> ";
}
function OngetPinpadCompleted(result)
{
	content = document.getElementById('result').innerHTML
	 document.getElementById('result').innerHTML= content +"<br/>OngetPinpadCompleted:"+result+"<br/> ";
	selectPinpad("Miura 865");
}

function OnTMSupdateCompleted(result)
{
	content = document.getElementById('result').innerHTML
	document.getElementById('result').innerHTML= content +"<br/>OnTMSupdateCompleted:"+result+"<br/> ";
}// JavaScript Document

function OntransAuthorizationCompleted (result)
{
    content = document.getElementById('result').innerHTML
    document.getElementById('result').innerHTML= content +"<br/>OntransAuthorizationCompleted:"+result+"<br/> ";
}

function OntransactionCaptureCompleted(result)
{
    content = document.getElementById('result').innerHTML
    document.getElementById('result').innerHTML= content +"<br/>OntransactionCaptureCompleted:"+result+"<br/> ";
}
function OntransactionVoidCompleted(result)
{
    content = document.getElementById('result').innerHTML
    document.getElementById('result').innerHTML= content +"<br/>OntransactionVoidCompleted:"+result+"<br/> ";
}
function OntransactionReturnCompleted(result)
{
    content = document.getElementById('result').innerHTML
    document.getElementById('result').innerHTML= content +"<br/>OntransactionReturnCompleted:"+result+"<br/> ";
}
