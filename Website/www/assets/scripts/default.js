(()=>{"use strict";class e{static prepareResponse(e){return{xhr:e,status:e.status,statusText:e.statusText,body:e.responseText,success:e.status>=200&&e.status<300||304===e.status}}static start(e,t){var s=arguments.length>2&&void 0!==arguments[2]?arguments[2]:null,i=arguments.length>3&&void 0!==arguments[3]?arguments[3]:{};return new Promise(((n,r)=>{var l=new XMLHttpRequest;if(l.open(e,t,!0),"object"==typeof i&&null!==i&&!1===Array.isArray(i)){var a=Object.keys(i);for(var o of a)l.setRequestHeader(o,i[o])}l.onload=()=>{var e=this.prepareResponse(l);e.success?n(e):r(e)},l.onerror=()=>{r(this.prepareResponse(l))},l.send(s)}))}static get(t){var s=arguments.length>1&&void 0!==arguments[1]?arguments[1]:{};return e.start("GET",t,null,s)}static post(t,s){var i=arguments.length>2&&void 0!==arguments[2]?arguments[2]:{};return s instanceof URLSearchParams?(i["Content-Type"]="application/x-www-form-urlencoded",e.start("POST",t,s.toString(),i)):"object"==typeof s&&null!==s||Array.isArray(s)?(i["Content-Type"]="application/json",e.start("POST",t,JSON.stringify(s),i)):e.start("POST",t,s,i)}static delete(t){var s=arguments.length>1&&void 0!==arguments[1]?arguments[1]:{};return e.start("DELETE",t,null,s)}}function t(e,t,s){return(t=function(e){var t=function(e,t){if("object"!=typeof e||null===e)return e;var s=e[Symbol.toPrimitive];if(void 0!==s){var i=s.call(e,"string");if("object"!=typeof i)return i;throw new TypeError("@@toPrimitive must return a primitive value.")}return String(e)}(e);return"symbol"==typeof t?t:String(t)}(t))in e?Object.defineProperty(e,t,{value:s,enumerable:!0,configurable:!0,writable:!0}):e[t]=s,e}class s{static init(){this.container=document.getElementById("explore_container"),this.popover=document.getElementById("explore_popover"),this.field=document.getElementById("explore_search_field"),this.link=document.getElementById("menu_explore_link"),this.container&&this.popover&&this.field&&this.link&&(this.container.addEventListener("click",(e=>(this.dismiss(),e.stopPropagation(),e.stopImmediatePropagation(),!1))),this.popover.addEventListener("click",(e=>(e.stopPropagation(),e.stopImmediatePropagation(),!1))),this.link.addEventListener("click",(e=>(e.stopPropagation(),e.preventDefault(),e.stopImmediatePropagation(),this.toggle(),!1))),this.field.addEventListener("input",(e=>{e.target.searchTimeout&&(clearTimeout(e.target.searchTimeout),e.target.searchTimeout=null),e.target.searchTimeout=setTimeout((()=>{this.search(this.field.value)}),1e3)})),document.getElementById("explore_results_back").addEventListener("click",(e=>{this.search("")})),document.getElementById("explore_results_more").addEventListener("click",(e=>{window.location=this.searchMoreURL})),window.addEventListener("blur",(e=>{this.dismiss()})))}static toggle(){"none"==this.container.style.display||""==this.container.style.display?this.present():this.dismiss()}static dismiss(){"none"!=this.container.style.display&&(this.container.style.display="none",this.link.className="",this.field.value="",this.displayResults())}static present(){if("block"!=this.container.style.display){var e=this.link.getBoundingClientRect();this.popover.style.top=e.bottom+"px",this.popover.style.left=Math.max(e.left+(e.width-320)/2,20)+"px",this.container.style.display="block",this.link.className="expanded"}}static search(t){if(t||(t=""),this.field.value!==t&&(this.field.value=t),""!==t){var s=new URLSearchParams;s.append("query",t.trim()),s.append("count",4),e.get("/search?".concat(s.toString()),{Accept:"application/json"}).then((e=>{try{this.displayResults(JSON.parse(e.body))}catch(e){console.log(e),this.displayResults()}})).catch((e=>{this.displayResults()}))}else this.displayResults()}static displayResults(){var e=arguments.length>0&&void 0!==arguments[0]?arguments[0]:null,t=document.getElementById("explore_results"),s=document.getElementById("explore_links");if(!e||!e.results)return t.style.display="none",void(s.style.display="block");for(var i=document.getElementById("explore_results_list");i.firstChild;)i.removeChild(i.firstChild);var n=e.results,r=e.total,l=e.terms;if(n.length>0){s.style.display="block",document.getElementById("explore_results_empty").style.display="none";var a=0;for(var o of n){var d=document.createElement("a");d.href=o.url;var p=document.createElement("span");if(p.className="result_type",p.appendChild(document.createTextNode(o.type)),d.appendChild(p),d.appendChild(document.createTextNode(o.title)),""!==o.summary){var c=document.createElement("span");c.className="result_preview",c.appendChild(document.createTextNode(o.summary)),d.appendChild(document.createElement("br")),d.appendChild(c)}var u=document.createElement("li");u.className=a%2==0?"result even":"result odd",a++,u.appendChild(d),i.appendChild(u)}}else s.style.display="none",document.getElementById("explore_results_empty").style.display="block";r>n.length?(document.getElementById("explore_results_right_button").style.display="block",this.searchMoreURL="/search/?query="+encodeURIComponent(l)):document.getElementById("explore_results_right_button").style.display="none",t.style.display="block",s.style.display="none"}}t(s,"container",null),t(s,"popover",null),t(s,"field",null),t(s,"link",null),t(s,"searchMoreURL",""),document.addEventListener("DOMContentLoaded",(()=>{s.init()}))})();