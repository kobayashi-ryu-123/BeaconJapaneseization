document.addEventListener("DOMContentLoaded",(function(){var e=document.getElementById("main_wrapper"),t=document.getElementById("navigator"),n=e.getElementsByClassName("page"),i=t.getElementsByClassName("pip"),a=0,s=document.getElementById("previous_button"),l=document.getElementById("next_button"),d=function(e){if(!(a===e||e<0||e>=n.length)){var t=n[a],d=n[e];e>a?t.classList.add("left"):t.classList.add("right"),d.classList.add("noanimation"),e>a?(d.classList.add("right"),d.classList.remove("left")):(d.classList.add("left"),d.classList.remove("right")),setTimeout((function(){d.classList.remove("noanimation"),d.classList.remove("left"),d.classList.remove("right")}),1),document.title=d.getAttribute("beacon-title");var o=0===e,c=e===n.length-1;s.disabled=o,l.innerText=c?"Finished":"Next";for(var r=0;r<i.length;r++)i[r].className=r===e?"pip active":"pip";a=e}};l.addEventListener("click",(function(e){e.preventDefault(),a>=n.length-1?window.location="beacon://finished":d(a+1)})),s.addEventListener("click",(function(e){e.preventDefault(),0!==a&&d(a-1)}));for(var o=function(e){var t,a=n[e],s=i[e];0===e?(document.title=a.getAttribute("beacon-title"),null!==s&&(s.className="pip active")):a.classList.add("right"),null!==s&&(t=e,s.addEventListener("click",(function(){d(t)})))},c=0;c<n.length;c++)o(c);var r=n.length>1,m=document.getElementById("skip_button");r?m.addEventListener("click",(function(e){e.preventDefault(),window.location="beacon://finished"})):(m.style.display="none",s.style.display="none"),1===n.length&&(l.innerText="Finished"),e.classList.add("animated")}));