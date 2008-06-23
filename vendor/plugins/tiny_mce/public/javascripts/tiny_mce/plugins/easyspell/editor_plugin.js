/* Import theme specific language pack */
tinyMCE.importPluginLanguagePack('easyspell', 'en');

/* Specify the name of the text field to spell check */
var spellCheckField="content";
var formName="";  //if form name is blank, spellchecker will use the first (or only) form it finds

function TinyMCE_easyspell_getControlHTML(control_name) {
    switch (control_name) {
        case "easyspell":
            return '<img id="{$editor_id}_easyspell" src="{$pluginurl}/images/easyspell.gif" title="{$lang_insert_easyspell}" width="20" height="20" class="mceButtonNormal" onmouseover="tinyMCE.switchClass(this,\'mceButtonOver\');" onmouseout="tinyMCE.restoreClass(this);" onmousedown="tinyMCE.restoreAndSwitchClass(this,\'mceButtonDown\');" onclick="tinyMCE.execInstanceCommand(\'{$editor_id}\',\'mceeasyspell\');" />';
    }
    return "";
}

/**
 * Executes the mceeasyspell command.
 */
function TinyMCE_easyspell_execCommand(editor_id, element, command, user_interface, value) {
    // Handle commands
    switch (command) {
        case "mceeasyspell":
            var template = new Array();
            template['file']   = '../../plugins/easyspell/easyspell.php?field='+spellCheckField+'&formName='+formName; // Relative to theme
            template['width']  = 400;
            template['height'] = 250;

            tinyMCE.openWindow(template, {editor_id : editor_id});
       return true;
   }
   // Pass to next handler in chain
   return false;
}


