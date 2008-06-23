<?
//Set this value to whatever you want to use for a personal dictionary file 
$user_dictionary_file = preg_replace('/[\W]+?/',"",$_COOKIE['user']);

if(isset($_POST['fieldtext'])) {
	$formfield=$_POST['field'];
	$formname=$_POST['formName'];
	$fieldtext=$_POST['fieldtext'];
	$start=isset($_POST['start'])?$_POST['start']:0; //what word to begin spelling at.  As it progresses through the words and posts back, no need to start from the beginning every time.
	$suggestions=array();
	$found_misspell=false;
	
	
	$words=array();
	$htmlitems = preg_split('/(<(?:[^<>]+(?:"[^"]*"|\'[^\']*\')?)+>)/',$fieldtext);//"
	foreach($htmlitems as $item) {
		if(strpos($item, "<")===false) {
			$wordarray=preg_split('/[\W]+?/', $item);
			foreach($wordarray as $worditem) {
				if($worditem!=""&&$worditem!=" "&&$worditem!="nbsp")
					$words[]=$worditem;
			}
		}			
	}

	$pspell_config = pspell_config_create("en");
	pspell_config_personal($pspell_config, "./dict/".$user_dictionary_file);
	$int = pspell_new_config($pspell_config);
	
	if($_POST['dictadd']!="") {
		pspell_add_to_personal($int, $_POST['dictadd']);
		pspell_save_wordlist($int);
	}
	
	for($i=$start;$i<count($words);$i++) {
		$currentword=$words[$i];
		if(strlen(trim($words[$i]))>2) {
			
			if (!pspell_check($int, $currentword)) {
			   $suggestions = pspell_suggest($int, $currentword);
			   $found_misspell=true;
			   $start=$i;
			   $misspell_index=$i;
			   break;
   			}
		}
	}
	?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<title>Spell Checker</title>
<link rel="stylesheet" type="text/css" href="easyspell.css" />
<script src="easyspell.js" type="text/javascript"></script>
</head>
	<?
	if($found_misspell) {
		echo "<body onload=\"document.forms[0].elements['replaceword'].focus();\">\n";
		echo "<form method=\"post\" action=\"{$_SERVER['PHP_SELF']}\">\n";
		echo "<table><tr><td colspan=\"2\"><h3>Not in Dictionary:</h3></td></tr><td class=\"bigcell\"><div id=\"wordbox\">.. {$words[$misspell_index-2]} {$words[$misspell_index-1]} <input type=\"text\" name=\"replaceword\" size=\"".strlen($words[$misspell_index])."\" value=\"$words[$misspell_index]\" /> {$words[$misspell_index+1]} {$words[$misspell_index+2]} ..</div></td><td><input type=\"button\" name=\"ignore\" value=\"Ignore\" onclick=\"ignore_one()\" /><br /><input type=\"button\" name=\"ignoreall\" value=\"Ignore All\" onclick=\"ignore_all()\" /></td></tr>\n";
		echo "<tr><td colspan=\"2\"><h3>Suggestions:</h3></td></tr><tr><td class=\"bigcell\"><select id=\"suggestions\" name=\"suggestions\" multiple=\"1\" size=\"3\" onchange=\"copyWord()\">".buildOptions($suggestions)."</select></td><td><input type=\"button\" name=\"replace\" value=\"Replace\" onclick=\"replace_one()\" /><br /><input type=\"button\" name=\"replaceall\" value=\"Replace All\" onclick=\"replace_all()\" /></td></tr></table>\n";
		echo "<input type=\"hidden\" name=\"fieldtext\" value=\"".str_replace("\"","&quot;",$fieldtext)."\" /><input type=\"hidden\" name=\"start\" value=\"$start\" /><input type=\"hidden\" name=\"errantword\" value=\"$words[$misspell_index]\" /><input type=\"hidden\" name=\"field\" value=\"$formfield\" /><input type=\"hidden\" name=\"formName\" value=\"$formname\"><input type=\"hidden\" name=\"dictadd\" value=\"\" />\n";
		echo "</form>\n";
	}
	else {
		echo "<body><form method=\"get\" class=\"complete\"><h2>Spell checking is complete.</h2><input type=\"button\" name=\"ok\" value=\"OK\" onclick=\"window.close();\" /></form>";
	}
	
}
else {
	if(isset($_REQUEST['field'])) {
		$textfield=$_REQUEST['field'];
		$formname=$_REQUEST['formName'];
		?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<title>Loading Spellchecker...</title>
<style type="text/css">
textarea {visibility:hidden;}
input {visibility:hidden;}
</style>
<script language="javascript" type="text/javascript">
<!--
function doLoad() {
	<?if($formname!="") echo "var parentform=window.opener.document.forms['$formname'];";
	else echo "var parentform=window.opener.document.forms[0];";?>
	if(parentform.elements['<?=$textfield?>']) {
		document.forms[0].elements['fieldtext'].value=window.opener.tinyMCE.getContent();
		document.forms[0].submit();
	}
	else {
		alert("EasySpell has been configured incorrectly; a non-existant text field has been specified.\n\nPlease check your EasySpell configuration.");
		window.close();
	}
}
//-->
</script>
</head>
<body onload="doLoad()">
Loading Spellchecker...<br /><br /><br /><br /><br /><br /><br /><br />
<form method="post" action="<?=$_SERVER['PHP_SELF']?>">
<textarea name="fieldtext"></textarea><input type="submit" value=" " />
<input type="hidden" name="field" value="<?=$textfield?>" /><input type="hidden" name="formName" value="<?=$formname?>" />
</form>
</body>
</html>
	
		<?
	}
}


function buildOptions($array) {
	$return="";
	if($array[0]!="") {
		foreach($array as $item) 
			$return.="<option value=\"$item\">$item</option>";
	}
	if($return=="") $return="<option value=\"\">(No Suggestions Available)</option>";
	return $return;
}
?>