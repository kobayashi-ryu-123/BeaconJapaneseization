(()=>{"use strict";function e(e,a,n,t,i,s,r){try{var o=e[s](r),d=o.value}catch(e){return void n(e)}o.done?a(d):Promise.resolve(d).then(t,i)}var a=function(){var a,n=(a=function*(){var e="macOS",a="windows-universal",n="windows-x64",t="windows-x86",i="windows-arm64",s=[n,e,t,i],r=!1;switch(navigator.platform){case"Win32":"userAgentData"in navigator&&(yield navigator.userAgentData.getHighEntropyValues(["architecture","bitness"]).then((a=>{32==a.bitness?(s=[t,n,i,e],r=!0):64==a.bitness&&("arm"==a.architecture?(s=[i,t,n,e],r=!0):"x86"==a.architecture&&(s=[n,t,i,e],r=!0))})).catch((()=>{}))),!1===r&&(s=[a,n,t,i,e],r=!0);break;case"MacIntel":s=[e,n,t,i],r=!0}var o=function(e,a,n){var t=arguments.length>3&&void 0!==arguments[3]?arguments[3]:"Download",i=document.createElement("div");i.classList.add("row");var s=document.createElement("div");s.classList.add("label"),s.innerHTML=a;var r=document.createElement("div");r.classList.add("button");var o=document.createElement("a");o.classList.add("button"),o.classList.add("default"),o.href=n,o.innerText=t,o.setAttribute("rel","nofollow"),r.appendChild(o),i.appendChild(s),i.appendChild(r),e.appendChild(i)},d=(d,l,c)=>{if(!1===r){var u=document.createElement("div");u.classList.add("row");var m=document.createElement("div");m.classList.add("full"),m.classList.add("text-red"),m.innerText="Sorry, this version of Beacon is not compatible with your device. But just in case a mistake was made, here are the download links.",u.appendChild(m),d.appendChild(u)}var p=!0;for(var v of s){var w=!0===c&&!0===r&&!0===p?'<span class="tag blue left-space">Recommended</span>':"";switch(v){case e:l.hasOwnProperty("mac_url")&&(o(d,"Mac".concat(w,'<br><span class="mini text-lighter">For macOS ').concat(l.mac_display_versions,"</span>"),l.mac_url),p=!1);break;case t:l.hasOwnProperty("win_32_url")&&(o(d,"Windows x86 32-bit".concat(w,'<br><span class="mini text-lighter">For 32-bit versions of ').concat(l.win_display_versions,"</span>"),l.win_32_url),p=!1);break;case n:l.hasOwnProperty("win_64_url")&&(o(d,"Windows x86 64-bit".concat(w,'<br><span class="mini text-lighter">For 64-bit versions of ').concat(l.win_display_versions,"</span>"),l.win_64_url),p=!1);break;case i:l.hasOwnProperty("win_arm64_url")&&(o(d,"Windows ARM 64-bit".concat(w,'<br><span class="mini text-lighter">For 64-bit versions of ').concat(l.win_arm_display_versions,"</span>"),l.win_arm64_url),p=!1);break;case a:l.hasOwnProperty("win_combo_url")&&(o(d,"Windows Universal".concat(w,'<br><span class="mini text-lighter">For all versions of ').concat(l.win_display_versions,"</span>"),l.win_combo_url),p=!1)}}o(d,'Engrams Database, updated <time datetime="'+l.engrams_date+'">'+l.engrams_date_display+"</time>",l.engrams_url),o(d,"Release Notes",l.history_url,"View")},l=document.getElementById("stable-table"),c=document.getElementById("prerelease-table"),u=document.getElementById("legacy-table"),m=downloadData.current;if(m){var p=document.createElement("div");p.classList.add("row");var v=document.createElement("div");v.classList.add("full"),v.innerText="Stable Version: Beacon "+m.build_display,p.appendChild(v),l.appendChild(p),d(l,m,!0)}var w=downloadData.preview;if(w){var h=document.createElement("div");h.classList.add("row");var _=document.createElement("div");_.classList.add("full"),_.innerText="Preview Version: Beacon "+w.build_display,h.appendChild(_),c.appendChild(h),d(c,w,!1)}else c.classList.add("hidden");var g=downloadData.legacy;if(g){var y=document.createElement("div");y.classList.add("row");var f=document.createElement("div");f.classList.add("full"),f.innerText="Legacy Version: Beacon "+g.build_display,y.appendChild(f),u.appendChild(y),d(u,g,!1)}else u.classList.add("hidden");document.getElementById("mac_version_requirements").innerText="macOS "+m.mac_display_versions,document.getElementById("win_version_requirements").innerText=m.win_display_versions},function(){var n=this,t=arguments;return new Promise((function(i,s){var r=a.apply(n,t);function o(a){e(r,i,s,o,d,"next",a)}function d(a){e(r,i,s,o,d,"throw",a)}o(void 0)}))});return function(){return n.apply(this,arguments)}}();document.addEventListener("DOMContentLoaded",(()=>{(()=>{var e=window.screen,a=e.width,n=e.height,t=a*window.devicePixelRatio,i=n*window.devicePixelRatio,s=(navigator.platform.indexOf("Mac"),navigator.platform.indexOf("Win")>-1),r=null;if((a<1280||n<720)&&(r="This screen may not be supported. A resolution of at least 1280x720 points is required.",t>=1280&&i>=720)){var o=Math.round(100*Math.min(t/1280,i/720));s&&(r="Your display scaling settings may prevent Beacon from fitting on your screen. If you experience trouble fitting Beacon's window on your screen, try changing your display scaling to "+o+'% or lower. <a href="https://www.windowscentral.com/how-set-custom-display-scaling-setting-windows-10#change_display_scaling_default_settings_windows10">Learn how to change scaling settings.</a>')}if(r){var d=document.getElementById("screenCompatibilityNotice");d&&(d.innerHTML=r,d.classList.remove("hidden"))}})(),a()}))})();