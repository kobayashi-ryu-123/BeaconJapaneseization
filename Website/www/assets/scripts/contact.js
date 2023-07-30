(()=>{"use strict";class e{static prepareResponse(e){return{xhr:e,status:e.status,statusText:e.statusText,body:e.responseText,success:e.status>=200&&e.status<300||304===e.status}}static start(e,t){var a=arguments.length>2&&void 0!==arguments[2]?arguments[2]:null,i=arguments.length>3&&void 0!==arguments[3]?arguments[3]:{};return new Promise(((n,l)=>{var s=new XMLHttpRequest;if(s.open(e,t,!0),"object"==typeof i&&null!==i&&!1===Array.isArray(i)){var o=Object.keys(i);for(var r of o)s.setRequestHeader(r,i[r])}s.onload=()=>{var e=this.prepareResponse(s);e.success?n(e):l(e)},s.onerror=()=>{l(this.prepareResponse(s))},s.send(a)}))}static get(t){var a=arguments.length>1&&void 0!==arguments[1]?arguments[1]:{};return e.start("GET",t,null,a)}static post(t,a){var i=arguments.length>2&&void 0!==arguments[2]?arguments[2]:{};return a instanceof URLSearchParams?(i["Content-Type"]="application/x-www-form-urlencoded",e.start("POST",t,a.toString(),i)):"object"==typeof a&&null!==a||Array.isArray(a)?(i["Content-Type"]="application/json",e.start("POST",t,JSON.stringify(a),i)):e.start("POST",t,a,i)}static delete(t){var a=arguments.length>1&&void 0!==arguments[1]?arguments[1]:{};return e.start("DELETE",t,null,a)}}function t(e,t,a){return(t=function(e){var t=function(e,t){if("object"!=typeof e||null===e)return e;var a=e[Symbol.toPrimitive];if(void 0!==a){var i=a.call(e,"string");if("object"!=typeof i)return i;throw new TypeError("@@toPrimitive must return a primitive value.")}return String(e)}(e);return"symbol"==typeof t?t:String(t)}(t))in e?Object.defineProperty(e,t,{value:a,enumerable:!0,configurable:!0,writable:!0}):e[t]=a,e}class a{static show(e){var t=arguments.length>1&&void 0!==arguments[1]?arguments[1]:null,a=arguments.length>2&&void 0!==arguments[2]?arguments[2]:"Ok";return this.confirm(e,t,a,null)}static confirm(e){var t=arguments.length>1&&void 0!==arguments[1]?arguments[1]:null,a=arguments.length>2&&void 0!==arguments[2]?arguments[2]:"Ok",i=arguments.length>3&&void 0!==arguments[3]?arguments[3]:"Cancel";return new Promise(((n,l)=>{var s=document.getElementById("overlay"),o=document.getElementById("dialog"),r=document.getElementById("dialog_message"),c=document.getElementById("dialog_explanation"),d=document.getElementById("dialog_action_button"),m=document.getElementById("dialog_cancel_button");s&&o&&r&&c&&d&&m?(s.className="exist",o.className="exist",setTimeout((()=>{s.className="exist visible",o.className="exist visible"}),10),r.innerText=e,c.innerText=t||"",d.clickHandler&&d.removeEventListener("click",d.clickHandler),m.clickHandler&&m.removeEventListener("click",m.clickHandler),d.clickHandler=()=>{this.hide(),setTimeout((()=>{n()}),300)},d.addEventListener("click",d.clickHandler),d.innerText=a,i?(m.clickHandler=()=>{this.hide(),setTimeout((()=>{l()}),300)},m.addEventListener("click",m.clickHandler),m.innerText=i):m.className="hidden"):l()}))}static hide(){var e=document.getElementById("overlay"),t=document.getElementById("dialog");e&&t&&(e.className="exist",t.className="exist",setTimeout((()=>{e.className="",t.className=""}),300))}static showModal(e){if(!this.activeModal){var t=document.getElementById("overlay"),a=document.getElementById(e);t&&a&&(t.classList.add("exist"),a.classList.add("exist"),this.activeModal=e,setTimeout((()=>{t.classList.add("visible"),a.classList.add("visible")}),10),this.viewportWatcher=setInterval((()=>{if(this.activeModal){document.querySelectorAll("#".concat(this.activeModal," .modal-content .content")).forEach((e=>{a.classList.toggle("scrolled",e.scrollHeight>e.clientHeight)}));var e=Math.max(document.documentElement.clientHeight||0,window.innerHeight||0);a.classList.toggle("centered",a.clientHeight>.75*e)}}),100))}}static hideModal(){return new Promise(((e,t)=>{if(this.activeModal){var a=document.getElementById("overlay"),i=document.getElementById(this.activeModal);a&&i?(this.viewportWatcher&&(clearInterval(this.viewportWatcher),this.viewportWatcher=null),a.classList.remove("visible"),i.classList.remove("visible"),setTimeout((()=>{a.classList.remove("exist"),i.classList.remove("exist"),this.activeModal=null,e()}),300)):t()}else t()}))}}t(a,"activeModal",null),t(a,"viewportWatcher",null),document.addEventListener("DOMContentLoaded",(()=>{var t=document.getElementById("contactForm"),i=document.getElementById("contactErrorNotice"),n=document.getElementById("contactNameField"),l=document.getElementById("contactEmailField"),s=document.getElementById("contactPlatformField"),o=document.getElementById("contactHostField"),r=document.getElementById("contactBodyField"),c=document.getElementById("contactActionButton"),d=document.getElementById("contactTimestampField"),m=document.getElementById("contactHashField"),u=document.getElementById("pageInitial"),v=document.getElementById("pageContactForm"),h=document.getElementById("showWebFormLink"),g=e=>{i&&(i.innerHTML=e,i.classList.remove("hidden")),c&&(c.disabled=!1)};if(t.addEventListener("submit",(t=>{if(t.preventDefault(),!(c&&i&&n&&l&&m&&r&&s&&d&&m))return console.log("Page is missing important elements"),!1;c.disabled=!0,i.classList.add("hidden");var u=n.value.trim();if(""!==u){var v=l.value.trim();if(""!==v){var h=o.value.trim();if(""!==h){var p=r.value.trim();if(""!==p){var y=s.value.trim();if(""!==y){var f=d.value.trim(),E=m.value.trim(),I=new URLSearchParams;I.append("name",u),I.append("email",v),I.append("platform",y),I.append("host",h),I.append("body",p),I.append("timestamp",f),I.append("hash",E),e.post("/help/ticket",I).then((()=>{r.value="",c.disabled=!1,a.show("Your support request has been submitted.","You will receive an email confirmation shortly.")})).catch((e=>{var t="Sorry, there was an HTTP ".concat(e.status," error.");try{var a=JSON.parse(e.body);a.message&&(t=a.message)}catch(e){console.log(e)}g(t)}))}else g("Please select one of the platforms from the menu")}else g("Please let us know how we can help")}else g("Please fill in the host field")}else g("Please enter a valid email address")}else g("Please enter a name")})),l){var p,y,f,E=null!==(p=null===(y=sessionStorage)||void 0===y?void 0:y.getItem("email"))&&void 0!==p?p:null===(f=localStorage)||void 0===f?void 0:f.getItem("email");E&&(l.value=E)}h&&h.addEventListener("click",(e=>{e.preventDefault(),u&&u.classList.add("hidden"),v&&v.classList.remove("hidden")}))}))})();