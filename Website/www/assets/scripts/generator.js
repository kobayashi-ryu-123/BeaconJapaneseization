(()=>{"use strict";document.addEventListener("DOMContentLoaded",(function(){var e=function(){var e=120,t=document.getElementById("dinoLevelField");t&&(e=Number.parseInt(t.value));var d=e/30,n=document.getElementById("difficulty_reference");if(n){var l=[];l.push("DifficultyOffset=1.0"),l.push("OverrideOfficialDifficulty="+d.toFixed(4)),n.value=l.join("\n")}var o=document.getElementById("create_difficulty_value");o&&(o.value=d.toFixed(1));var a=document.getElementById("paste_difficulty_value");a&&(a.value=d.toFixed(1));var m=document.getElementById("upload_difficulty_value");m&&(m.value=d.toFixed(1))},t=document.getElementById("dino_level_field");t&&t.addEventListener("input",e),e(),null!==document.getElementById("mode_tabs")&&(document.getElementById("mode_tabs_new").addEventListener("click",(function(){document.getElementById("mode_view_new").style.display="block",document.getElementById("mode_view_paste").style.display="none",document.getElementById("mode_view_upload").style.display="none",document.getElementById("mode_tabs_new").className="selected",document.getElementById("mode_tabs_paste").className="",document.getElementById("mode_tabs_upload").className=""})),document.getElementById("mode_tabs_paste").addEventListener("click",(function(){document.getElementById("mode_view_new").style.display="none",document.getElementById("mode_view_paste").style.display="block",document.getElementById("mode_view_upload").style.display="none",document.getElementById("mode_tabs_new").className="",document.getElementById("mode_tabs_paste").className="selected",document.getElementById("mode_tabs_upload").className=""})),document.getElementById("mode_tabs_upload").addEventListener("click",(function(){document.getElementById("mode_view_new").style.display="none",document.getElementById("mode_view_paste").style.display="none",document.getElementById("mode_view_upload").style.display="block",document.getElementById("mode_tabs_new").className="",document.getElementById("mode_tabs_paste").className="",document.getElementById("mode_tabs_upload").className="selected"})));var d=document.getElementById("copy_button");d&&d.addEventListener("click",(function(e){var t=document.getElementById("content_output");if(t)try{navigator.clipboard.writeText(t.value),e.currentTarget.innerText="Copied!",e.currentTarget.disabled=!0,setTimeout((function(){e.currentTarget.innerText="Copy",e.currentTarget.disabled=!1}),3e3)}catch(e){alert("Looks like this browser does not support automatic copy. You will need to do it yourself.")}}));var n=document.getElementById("upload_file_selector"),l=document.getElementById("upload_file_selector_button");n&&l&&(l.addEventListener("click",(function(e){return n.click(),e.preventDefault&&e.preventDefault(),!1})),n.addEventListener("change",(function(e){""!==e.currentTarget.value&&e.currentTarget.form.submit()})))}))})();