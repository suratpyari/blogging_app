**************************************************************************
EASYSPELL SPELL CHECKER PLUGIN FOR TINYMCE
Version 1.0
Created by: Matt Curtis, matt@curtiseconsulting.com
**************************************************************************

DESCRIPTION: This spell checker plugin easily integrates with TinyMCE and 
allows for a spell check capability similar in function to Microsoft Word.
Includes 'Replace', 'Replace All', 'Ignore', and 'Ignore All' functionality.

PREREQUISITES: PHP, with phpSpell installed on the web server.  This can 
be verified by doing a phpinfo() page and searching for '--with-pspell' on 
the Configure Command area.

INSTALLATION: Extract the contents of this zip file into 
tinymce/jscripts/tinymce/plugins/.  That is, the plugins folder.  This will
create a 'easyspell' folder in the plugins directory.  Edit line 5 of the
editor_plugin.js file to specify the name of the tinyMCE field you will be
spell checking.  If you have more than one form on the page, also specify 
the name of the form on line 6.  (If you leave it blank, the spell checker
will use the first form on the page.)  Then, edit line 3 of easyspell.php 
to reflect some sort of naming system for users.  This name will be the 
name of the file used to store their personal dictionary.  I've defaulted
it to use a cookie value called 'user'.  If you specify a static value,
the spell checker will use that file for everybody.  

To configure TinyMCE to use the installed plugin, add "easyspell" to the 
plugins line in tinymce.init().  

For example: plugins : "easyspell",

Wherever you want the button to appear in the toolbar, add "easyspell".

For example: theme_advanced_buttons1 : "bold,italic,underline,easyspell",

Further instructions for adding plugins to TinyMCE can be found in the 
original TinyMCE help.  

LIMITATIONS: Currently, the only language supported is English (American),
But using others would be a relatively easy modification in the php code.
Also, I've only developed and tested this for use with one TinyMCE field.
Developed and tested on PHP 4.3.11 on Apache/Linux.  Browser support: 
Tested and verified in IE6/Win and Firefox 1.06/win.  



