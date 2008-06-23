function replace_one() {
	var flags="";
	doreplace(flags);
}
function replace_all() {
	var flags="g";
	doreplace(flags);
}

function doreplace(flags) {
	var myform=document.forms[0];
	var fieldtext = myform.elements['fieldtext'];
	var replaceword = myform.elements['replaceword'];
	var errantword = myform.elements['errantword'].value;
	
	if(flags!="")
		var myRE=new RegExp(errantword,flags)
	else
		var myRE=new RegExp(errantword);
	
	var newvalue=fieldtext.value.replace(myRE,replaceword.value);
	
	fieldtext.value=newvalue;
	
	var parentfield=myform.elements['field'].value;
	var parentform=myform.elements['formName'].value;
	if(parentform=="") parentform=0;

	window.opener.tinyMCE.setContent(fieldtext.value);
	window.opener.tinyMCE.triggerSave();
	document.forms[0].submit();
}

function ignore_one() {
	var myform=document.forms[0];
	var start = myform.elements['start'].value;
	myform.elements['start'].value = (start*1)+1;
	myform.submit();
}

function ignore_all() {
	var myform=document.forms[0];
	var errantword = myform.elements['errantword'].value;
	myform.elements['dictadd'].value=errantword;
	myform.submit();
}

function copyWord() {
	var myform=document.forms[0];
	var selectedWord=myform.elements['suggestions'].options[myform.elements['suggestions'].selectedIndex].value;
	myform.elements['replaceword'].value=selectedWord;
}
