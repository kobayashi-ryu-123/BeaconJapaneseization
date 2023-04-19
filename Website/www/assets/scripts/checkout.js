"use strict";function _defineProperty(obj,key,value){key=_toPropertyKey(key);if(key in obj){Object.defineProperty(obj,key,{value:value,enumerable:true,configurable:true,writable:true})}else{obj[key]=value}return obj}function _toPropertyKey(arg){var key=_toPrimitive(arg,"string");return typeof key==="symbol"?key:String(key)}function _toPrimitive(input,hint){if(typeof input!=="object"||input===null)return input;var prim=input[Symbol.toPrimitive];if(prim!==undefined){var res=prim.call(input,hint||"default");if(typeof res!=="object")return res;throw new TypeError("@@toPrimitive must return a primitive value.")}return(hint==="string"?String:Number)(input)}function _classPrivateFieldInitSpec(obj,privateMap,value){_checkPrivateRedeclaration(obj,privateMap);privateMap.set(obj,value)}function _checkPrivateRedeclaration(obj,privateCollection){if(privateCollection.has(obj)){throw new TypeError("Cannot initialize the same private elements twice on an object")}}function _classPrivateFieldGet(receiver,privateMap){var descriptor=_classExtractFieldDescriptor(receiver,privateMap,"get");return _classApplyDescriptorGet(receiver,descriptor)}function _classApplyDescriptorGet(receiver,descriptor){if(descriptor.get){return descriptor.get.call(receiver)}return descriptor.value}function _classPrivateFieldSet(receiver,privateMap,value){var descriptor=_classExtractFieldDescriptor(receiver,privateMap,"set");_classApplyDescriptorSet(receiver,descriptor,value);return value}function _classExtractFieldDescriptor(receiver,privateMap,action){if(!privateMap.has(receiver)){throw new TypeError("attempted to "+action+" private field on non-instance")}return privateMap.get(receiver)}function _classApplyDescriptorSet(receiver,descriptor,value){if(descriptor.set){descriptor.set.call(receiver,value)}else{if(!descriptor.writable){throw new TypeError("attempted to set read only private field")}descriptor.value=value}}var StatusOwns="owns";var StatusBuying="buying";var StatusInCart="in-cart";var StatusNone="none";var MaxRenewalCount=5;var validateEmail=email=>{var re=/^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;return re.test(String(email).trim().toLowerCase())};var _id=new WeakMap;var _products=new WeakMap;var _isGift=new WeakMap;class BeaconCartItem{constructor(config){_classPrivateFieldInitSpec(this,_id,{writable:true,value:null});_classPrivateFieldInitSpec(this,_products,{writable:true,value:{}});_classPrivateFieldInitSpec(this,_isGift,{writable:true,value:false});if(config){_classPrivateFieldSet(this,_id,config.id);_classPrivateFieldSet(this,_products,config.products);_classPrivateFieldSet(this,_isGift,config.isGift)}else{_classPrivateFieldSet(this,_id,crypto.randomUUID())}}get id(){return _classPrivateFieldGet(this,_id)}get isGift(){return _classPrivateFieldGet(this,_isGift)}set isGift(newValue){_classPrivateFieldSet(this,_isGift,newValue)}get productIds(){return Object.keys(_classPrivateFieldGet(this,_products))}get count(){return Object.keys(_classPrivateFieldGet(this,_products)).length}reset(){_classPrivateFieldSet(this,_products,{})}add(productId,quantity){this.setQuantity(productId,this.getQuantity(productId)+quantity)}remove(productId,quantity){this.setQuantity(productId,this.getQuantity(productId)-quantity)}getQuantity(productId){var _classPrivateFieldGet2;return(_classPrivateFieldGet2=_classPrivateFieldGet(this,_products)[productId])!==null&&_classPrivateFieldGet2!==void 0?_classPrivateFieldGet2:0}setQuantity(productId,quantity){if(quantity<=0){if(_classPrivateFieldGet(this,_products).hasOwnProperty(productId)){delete _classPrivateFieldGet(this,_products)[productId]}}else{_classPrivateFieldGet(this,_products)[productId]=quantity}}toJSON(){return{id:_classPrivateFieldGet(this,_id),products:_classPrivateFieldGet(this,_products),isGift:_classPrivateFieldGet(this,_isGift)}}get fingerprint(){var sorted=Object.keys(_classPrivateFieldGet(this,_products)).sort().reduce((obj,key)=>{obj[key]=_classPrivateFieldGet(this,_products)[key];return obj},{});return btoa(JSON.stringify({id:_classPrivateFieldGet(this,_id),products:sorted,isGift:_classPrivateFieldGet(this,_isGift)}))}get hasArk(){var _Products,_Products$Ark,_Products$Ark$Base;return this.getQuantity((_Products=Products)===null||_Products===void 0?void 0:(_Products$Ark=_Products.Ark)===null||_Products$Ark===void 0?void 0:(_Products$Ark$Base=_Products$Ark.Base)===null||_Products$Ark$Base===void 0?void 0:_Products$Ark$Base.ProductId)>0}get hasArkSA(){var _Products2,_Products2$ArkSA,_Products2$ArkSA$Base,_Products3,_Products3$ArkSA,_Products3$ArkSA$Upgr;return this.getQuantity((_Products2=Products)===null||_Products2===void 0?void 0:(_Products2$ArkSA=_Products2.ArkSA)===null||_Products2$ArkSA===void 0?void 0:(_Products2$ArkSA$Base=_Products2$ArkSA.Base)===null||_Products2$ArkSA$Base===void 0?void 0:_Products2$ArkSA$Base.ProductId)>0||this.getQuantity((_Products3=Products)===null||_Products3===void 0?void 0:(_Products3$ArkSA=_Products3.ArkSA)===null||_Products3$ArkSA===void 0?void 0:(_Products3$ArkSA$Upgr=_Products3$ArkSA.Upgrade)===null||_Products3$ArkSA$Upgr===void 0?void 0:_Products3$ArkSA$Upgr.ProductId)>0}get arkSAYears(){var _Products4,_Products4$ArkSA,_Products4$ArkSA$Base,_Products5,_Products5$ArkSA,_Products5$ArkSA$Upgr,_Products6,_Products6$ArkSA,_Products6$ArkSA$Rene;return Math.min(this.getQuantity((_Products4=Products)===null||_Products4===void 0?void 0:(_Products4$ArkSA=_Products4.ArkSA)===null||_Products4$ArkSA===void 0?void 0:(_Products4$ArkSA$Base=_Products4$ArkSA.Base)===null||_Products4$ArkSA$Base===void 0?void 0:_Products4$ArkSA$Base.ProductId)+this.getQuantity((_Products5=Products)===null||_Products5===void 0?void 0:(_Products5$ArkSA=_Products5.ArkSA)===null||_Products5$ArkSA===void 0?void 0:(_Products5$ArkSA$Upgr=_Products5$ArkSA.Upgrade)===null||_Products5$ArkSA$Upgr===void 0?void 0:_Products5$ArkSA$Upgr.ProductId)+this.getQuantity((_Products6=Products)===null||_Products6===void 0?void 0:(_Products6$ArkSA=_Products6.ArkSA)===null||_Products6$ArkSA===void 0?void 0:(_Products6$ArkSA$Rene=_Products6$ArkSA.Renewal)===null||_Products6$ArkSA$Rene===void 0?void 0:_Products6$ArkSA$Rene.ProductId),10)}build(isGift,withArk,arkSAYears){this.reset();this.isGift=isGift;if(withArk&&(isGift||cart.arkLicense===null)){this.setQuantity(Products.Ark.Base.ProductId,1)}if(arkSAYears>0){arkSAYears=Math.min(arkSAYears,MaxRenewalCount);if(isGift){if(withArk){this.setQuantity(Products.ArkSA.Upgrade.ProductId,1)}else{this.setQuantity(Products.ArkSA.Base.ProductId,1)}if(arkSAYears>1){this.setQuantity(Products.ArkSA.Renewal.ProductId,arkSAYears-1)}}else{if(cart.arkSALicense!==null){this.setQuantity(Products.ArkSA.Renewal.ProductId,arkSAYears)}else{if(withArk||cart.arkLicense!==null){this.setQuantity(Products.ArkSA.Upgrade.ProductId,1)}else{this.setQuantity(Products.ArkSA.Base.ProductId,1)}if(arkSAYears>1){this.setQuantity(Products.ArkSA.Renewal.ProductId,arkSAYears-1)}}}}}rebuild(){var oldFingerprint=this.fingerprint;this.build(this.isGift,this.hasArk,this.arkSAYears);return this.fingerprint!==oldFingerprint}consume(otherLineItem){if(!otherLineItem){return}if(this.isGift!==otherLineItem.isGift){throw new Error("Cannot merge a gift item with a non-gift item.")}var includeArk=this.hasArk||otherLineItem.hasArk;var arkSAYears=this.arkSAYears+otherLineItem.arkSAYears;this.build(this.isGift,includeArk,arkSAYears)}}var _items=new WeakMap;var _email=new WeakMap;var _emailVerified=new WeakMap;var _licenses=new WeakMap;class BeaconCart{constructor(){var saved=arguments.length>0&&arguments[0]!==undefined?arguments[0]:null;_classPrivateFieldInitSpec(this,_items,{writable:true,value:[]});_classPrivateFieldInitSpec(this,_email,{writable:true,value:null});_classPrivateFieldInitSpec(this,_emailVerified,{writable:true,value:false});_classPrivateFieldInitSpec(this,_licenses,{writable:true,value:[]});_defineProperty(this,"emailChanged",email=>{});if(saved){try{var parsed=JSON.parse(saved);_classPrivateFieldSet(this,_email,parsed.email);_classPrivateFieldSet(this,_items,parsed.items.reduce((items,savedItem)=>{var cartItem=new BeaconCartItem(savedItem);if(cartItem.count>0){items.push(cartItem)}return items},[]));_classPrivateFieldSet(this,_licenses,parsed.licenses)}catch(e){console.log("Failed to load saved cart")}}}reset(){_classPrivateFieldSet(this,_items,[]);_classPrivateFieldSet(this,_email,null);_classPrivateFieldSet(this,_emailVerified,false);_classPrivateFieldSet(this,_licenses,[]);this.save()}toJSON(){return{email:_classPrivateFieldGet(this,_email),items:_classPrivateFieldGet(this,_items).reduce((items,cartItem)=>{if(cartItem.count>0){items.push(cartItem)}return items},[]),licenses:_classPrivateFieldGet(this,_licenses)}}save(){localStorage.setItem("beacon-cart",JSON.stringify(this))}static load(){return new this(localStorage.getItem("beacon-cart"))}add(item){_classPrivateFieldGet(this,_items).push(item);this.save()}remove(item){_classPrivateFieldSet(this,_items,_classPrivateFieldGet(this,_items).filter(cartItem=>cartItem.id!==item.id));this.save()}hasProduct(productId){var isGift=arguments.length>1&&arguments[1]!==undefined?arguments[1]:false;for(var lineItem of _classPrivateFieldGet(this,_items)){if(lineItem.getQuantity(productId)>0&&lineItem.isGift===isGift){return true}}return false}get email(){return _classPrivateFieldGet(this,_email)}setEmail(newEmail){return new Promise((resolve,reject)=>{if(newEmail===_classPrivateFieldGet(this,_email)){resolve({newEmail,cartChanged:false});return}var rebuildCart=()=>{var cartItem=this.personalCartItem;if(!cartItem){return false}return cartItem.rebuild()};if(newEmail===null){_classPrivateFieldSet(this,_email,null);_classPrivateFieldSet(this,_emailVerified,false);_classPrivateFieldSet(this,_licenses,[]);var cartChanged=rebuildCart();this.save();resolve({newEmail:null,cartChanged});return}if(!validateEmail(newEmail)){reject("Address is not valid");return}var params=new URLSearchParams;params.append("email",newEmail);BeaconWebRequest.get("/omni/lookup?".concat(params.toString())).then(response=>{var info=JSON.parse(response.body);_classPrivateFieldSet(this,_email,info.email);_classPrivateFieldSet(this,_emailVerified,info.verified);_classPrivateFieldSet(this,_licenses,info.purchases);var cartChanged=rebuildCart();this.save();resolve({newEmail,cartChanged})}).catch(error=>{_classPrivateFieldSet(this,_email,null);_classPrivateFieldSet(this,_emailVerified,false);_classPrivateFieldSet(this,_licenses,[]);rebuildCart();this.save();reject(error.statusText)})})}get emailVerified(){return _classPrivateFieldGet(this,_emailVerified)}get checkingEmail(){return false}get items(){return[..._classPrivateFieldGet(this,_items)]}get count(){return _classPrivateFieldGet(this,_items).reduce((bundles,cartItem)=>{if(cartItem.count>0){bundles++}return bundles},0)}findLicense(productId){for(var license of _classPrivateFieldGet(this,_licenses)){if(license.product_id===productId){return license}}return null}get arkLicense(){var _Products7,_Products7$Ark,_Products7$Ark$Base;return this.findLicense((_Products7=Products)===null||_Products7===void 0?void 0:(_Products7$Ark=_Products7.Ark)===null||_Products7$Ark===void 0?void 0:(_Products7$Ark$Base=_Products7$Ark.Base)===null||_Products7$Ark$Base===void 0?void 0:_Products7$Ark$Base.ProductId)}get arkSALicense(){var _Products8,_Products8$ArkSA,_Products8$ArkSA$Base;return this.findLicense((_Products8=Products)===null||_Products8===void 0?void 0:(_Products8$ArkSA=_Products8.ArkSA)===null||_Products8$ArkSA===void 0?void 0:(_Products8$ArkSA$Base=_Products8$ArkSA.Base)===null||_Products8$ArkSA$Base===void 0?void 0:_Products8$ArkSA$Base.ProductId)}get ark2License(){return null}get personalCartItem(){for(var cartItem of _classPrivateFieldGet(this,_items)){if(cartItem.isGift===false){return cartItem}}return null}}var cart=BeaconCart.load();var _history=new WeakMap;var _timeout=new WeakMap;class ViewManager{constructor(initialView){_classPrivateFieldInitSpec(this,_history,{writable:true,value:[]});_classPrivateFieldInitSpec(this,_timeout,{writable:true,value:null});_classPrivateFieldGet(this,_history).push(initialView)}get currentView(){return _classPrivateFieldGet(this,_history).slice(-1)}back(){var animated=arguments.length>0&&arguments[0]!==undefined?arguments[0]:true;if(_classPrivateFieldGet(this,_history).length<=1){return false}this.switchView(_classPrivateFieldGet(this,_history)[_classPrivateFieldGet(this,_history).length-2],animated);_classPrivateFieldSet(this,_history,_classPrivateFieldGet(this,_history).slice(0,_classPrivateFieldGet(this,_history).length-2));return true}clearHistory(){if(_classPrivateFieldGet(this,_history).length<=1){return}_classPrivateFieldSet(this,_history,_classPrivateFieldGet(this,_history).slice(-1))}switchView(newView){var animated=arguments.length>1&&arguments[1]!==undefined?arguments[1]:true;if(this.currentView==newView){return}if(_classPrivateFieldGet(this,_timeout)){clearTimeout(_classPrivateFieldGet(this,_timeout));_classPrivateFieldSet(this,_timeout,null)}var currentElement=document.getElementById(this.currentView);var newElement=document.getElementById(newView);_classPrivateFieldGet(this,_history).push(newView);if(animated){currentElement.classList.add("invisible");_classPrivateFieldSet(this,_timeout,setTimeout(()=>{currentElement.classList.add("hidden");newElement.classList.remove("hidden");_classPrivateFieldSet(this,_timeout,setTimeout(()=>{newElement.classList.remove("invisible");_classPrivateFieldSet(this,_timeout,null)},150))},150))}else{currentElement.classList.add("hidden");currentElement.classList.add("invisible");newElement.classList.remove("invisible");newElement.classList.remove("hidden")}}}var wizardViewManager=new ViewManager("checkout-wizard-start");var storeViewManager=new ViewManager("page-landing");var formatCurrency=amount=>{var formatter=BeaconCurrency.defaultFormatter;if(formatter){return formatter(amount)}else{return amount}};var updateCart=()=>{};document.addEventListener("DOMContentLoaded",()=>{var buyButton=document.getElementById("buy-button");var landingButton=document.getElementById("cart-back-button");var cartContainer=document.getElementById("storefront-cart");var emailDialog={cancelButton:document.getElementById("checkout-email-cancel"),actionButton:document.getElementById("checkout-email-action"),emailField:document.getElementById("checkout-email-field"),errorField:document.getElementById("checkout-email-error"),allowsSkipping:false,successFunction:function(cartChanged){},init:function(){var actionFunction=email=>{this.actionButton.disabled=true;this.cancelButton.disabled=true;this.errorField.classList.add("hidden");cart.setEmail(email).then(_ref=>{var{newEmail,cartChanged}=_ref;BeaconDialog.hideModal();setTimeout(()=>{this.successFunction(cartChanged)},310)}).catch(reason=>{this.errorField.innerText=reason;this.errorField.classList.remove("hidden")}).finally(()=>{this.actionButton.disabled=false;this.cancelButton.disabled=false})};this.actionButton.addEventListener("click",ev=>{ev.preventDefault();actionFunction(this.emailField.value)});this.cancelButton.addEventListener("click",ev=>{ev.preventDefault();if(this.allowsSkipping){actionFunction(null);return}BeaconDialog.hideModal()})},present:function(allowSkipping,successFunction){this.allowsSkipping=allowSkipping;this.successFunction=successFunction;if(cart.email){this.emailField.value=cart.email}else{this.emailField.value=sessionStorage.getItem("email")||localStorage.getItem("email")||""}if(allowSkipping){this.cancelButton.innerText="Skip For Now"}else{this.cancelButton.innerText="Cancel"}BeaconDialog.showModal("checkout-email")}};emailDialog.init();var wizard={editCartItem:null,cancelButton:document.getElementById("checkout-wizard-cancel"),actionButton:document.getElementById("checkout-wizard-action"),giftCheck:document.getElementById("checkout-wizard-gift-check"),arkSACheck:document.getElementById("checkout-wizard-arksa-check"),arkCheck:document.getElementById("checkout-wizard-ark-check"),arkPriceField:document.getElementById("checkout-wizard-ark-price"),arkSAPriceField:document.getElementById("checkout-wizard-arksa-full-price"),arkSAUpgradePriceField:document.getElementById("checkout-wizard-arksa-discount-price"),arkSAStatusField:document.getElementById("checkout-wizard-status-arksa"),arkStatusField:document.getElementById("checkout-wizard-status-ark"),arkSADurationGroup:document.getElementById("checkout-wizard-arksa-duration-group"),arkSADurationField:document.getElementById("checkout-wizard-arksa-duration-field"),arkSADurationUpButton:document.getElementById("checkout-wizard-arksa-yearup-button"),arkSADurationDownButton:document.getElementById("checkout-wizard-arksa-yeardown-button"),arkSAPromoField:document.getElementById("checkout-wizard-promo-arksa"),init:function(){this.cancelButton.addEventListener("click",ev=>{ev.preventDefault();BeaconDialog.hideModal()});this.actionButton.addEventListener("click",ev=>{ev.preventDefault();var isGift=this.giftCheck.checked;var includeArk=this.arkCheck.disabled===false&&this.arkCheck.checked;var includeArkSA=this.arkSACheck.disabled===false&&this.arkSACheck.checked;if((includeArk||includeArkSA)===false){return}var arkSAYears=includeArkSA?parseInt(this.arkSADurationField.value)||1:0;var lineItem;if(this.editCartItem){lineItem=this.editCartItem}else{lineItem=new BeaconCartItem;lineItem.isGift=isGift}lineItem.build(isGift,includeArk,arkSAYears);if(Boolean(this.editCartItem)===false){var personalCartItem=cart.personalCartItem;if(isGift===false&&Boolean(personalCartItem)===true){personalCartItem.consume(lineItem)}else{cart.add(lineItem)}}cart.save();updateCart();goToCart();BeaconDialog.hideModal()});this.giftCheck.addEventListener("change",ev=>{this.update()});this.arkCheck.addEventListener("change",ev=>{this.update()});this.arkSACheck.addEventListener("change",ev=>{this.update()});this.arkSADurationField.addEventListener("input",ev=>{this.update()});var nudgeArkSADuration=amount=>{var originalValue=parseInt(this.arkSADurationField.value);var newValue=originalValue+amount;if(newValue>MaxRenewalCount||newValue<1){this.arkSADurationGroup.classList.add("shake");setTimeout(()=>{this.arkSADurationGroup.classList.remove("shake")},400);newValue=Math.max(Math.min(newValue,MaxRenewalCount),1)}if(originalValue!==newValue){this.arkSADurationField.value=newValue;this.arkSACheck.checked=true;this.update()}};this.arkSADurationUpButton.addEventListener("click",ev=>{ev.preventDefault();nudgeArkSADuration(1)});this.arkSADurationDownButton.addEventListener("click",ev=>{ev.preventDefault();nudgeArkSADuration(-1)})},present:function(){var editCartItem=arguments.length>0&&arguments[0]!==undefined?arguments[0]:null;this.editCartItem=editCartItem;this.arkCheck.checked=(editCartItem===null||editCartItem===void 0?void 0:editCartItem.hasArk)||false;this.arkSACheck.checked=(editCartItem===null||editCartItem===void 0?void 0:editCartItem.hasArkSA)||false;this.arkCheck.disabled=false;this.arkSACheck.disabled=false;if(editCartItem){this.giftCheck.checked=editCartItem.isGift;this.giftCheck.disabled=true}else{this.giftCheck.checked=false;this.giftCheck.disabled=false}if(editCartItem){this.arkSADurationField.value=editCartItem.arkSAYears}else{this.arkSADurationField.value="1"}this.cancelButton.innerText="Cancel";this.update();BeaconDialog.showModal("checkout-wizard")},getGameStatus:function(){var gameStatus={Ark:StatusNone,ArkSA:StatusNone};var personalCartItem=cart.personalCartItem;var isEditing=Boolean(this.editCartItem);var isGift=this.giftCheck.checked;if(isGift){gameStatus.Ark=this.arkCheck.disabled==false&&this.arkCheck.checked?StatusBuying:StatusNone;gameStatus.ArkSA=this.arkSACheck.disabled==false&&this.arkSACheck.checked?StatusBuying:StatusNone}else{if(cart.arkLicense){gameStatus.Ark=StatusOwns}else if(personalCartItem&&(isEditing===false||personalCartItem.id!==this.editCartItem.id)&&personalCartItem.hasArk){gameStatus.Ark=StatusInCart}else if(this.arkCheck.disabled===false&&this.arkCheck.checked){gameStatus.Ark=StatusBuying}else{gameStatus.Ark=StatusNone}if(cart.arkSALicense){gameStatus.ArkSA=StatusOwns}else if(personalCartItem&&(isEditing===false||personalCartItem.id!==this.editCartItem.id)&&personalCartItem.hasArkSA){gameStatus.ArkSA=StatusInCart}else if(this.arkSACheck.disabled===false&&this.arkSACheck.checked){gameStatus.ArkSA=StatusBuying}else{gameStatus.ArkSA=StatusNone}}return gameStatus},update:function(){var gameStatus=this.getGameStatus();var arkSAFullPrice=Products.ArkSA.Base.Price;var arkSAEffectivePrice=Products.ArkSA.Base.Price;var arkSAYears=Math.min(Math.max(parseInt(this.arkSADurationField.value)||1,1),MaxRenewalCount);if(parseInt(this.arkSADurationField.value)!==arkSAYears&&document.activeElement!==this.arkSADurationField){this.arkSADurationField.value=arkSAYears}var arkSAAdditionalYears=Math.max(arkSAYears-1,0);var discount=Math.round((Products.ArkSA.Base.Price-Products.ArkSA.Upgrade.Price)/Products.ArkSA.Base.Price*100);this.arkSAPromoField.innerText="".concat(discount,"% off first year when bundled with ").concat(Products.Ark.Base.Name);if(gameStatus.ArkSA===StatusOwns){var license=ark.arkSALicense;arkSAFullPrice=Products.ArkSA.Renewal.Price*arkSAYears;arkSAEffectivePrice=arkSAFullPrice;this.arkSAPromoField.innerText="";this.arkSAPromoField.classList.add("hidden")}else if(gameStatus.ArkSA===StatusInCart){arkSAFullPrice=Products.ArkSA.Renewal.Price*arkSAYears;arkSAEffectivePrice=arkSAFullPrice;this.arkSAStatusField.innerText="Additional renewal years for ".concat(Products.ArkSA.Base.Name," in your cart.");this.arkSAPromoField.innerText="";this.arkSAPromoField.classList.add("hidden")}else if(gameStatus.Ark!==StatusNone){arkSAFullPrice=Products.ArkSA.Base.Price+Products.ArkSA.Renewal.Price*arkSAAdditionalYears;arkSAEffectivePrice=Products.ArkSA.Upgrade.Price+Products.ArkSA.Renewal.Price*arkSAAdditionalYears;var discountLanguage=gameStatus.Ark===StatusOwns?"because you own":"when bundled with";this.arkSAStatusField.innerText="Includes first year of app updates. Additional years cost ".concat(formatCurrency(Products.ArkSA.Renewal.Price)," each.");this.arkSAPromoField.innerText="".concat(discount,"% off first year ").concat(discountLanguage," ").concat(Products.Ark.Base.Name);this.arkSAPromoField.classList.remove("hidden")}else{this.arkSAStatusField.innerText="Includes first year of app updates. Additional years cost ".concat(formatCurrency(Products.ArkSA.Renewal.Price)," each.");this.arkSAPromoField.innerText="".concat(discount,"% off first year when bundled with ").concat(Products.Ark.Base.Name);this.arkSAPromoField.classList.remove("hidden");arkSAFullPrice=Products.ArkSA.Base.Price+Products.ArkSA.Renewal.Price*arkSAAdditionalYears;arkSAEffectivePrice=arkSAFullPrice}this.arkSAPriceField.classList.toggle("checkout-wizard-discounted",arkSAFullPrice!=arkSAEffectivePrice);this.arkSAPriceField.innerText=formatCurrency(arkSAFullPrice);this.arkSAUpgradePriceField.classList.toggle("hidden",arkSAFullPrice==arkSAEffectivePrice);this.arkSAUpgradePriceField.innerText=formatCurrency(arkSAEffectivePrice);if(gameStatus.Ark===StatusOwns){this.arkStatusField.innerText="You already own ".concat(Products.Ark.Base.Name,".");this.arkCheck.disabled=true;this.arkCheck.checked=false}else if(gameStatus.Ark===StatusInCart){this.arkStatusField.innerText="".concat(Products.Ark.Base.Name," is already in your cart.");this.arkCheck.disabled=true;this.arkCheck.checked=false}else{this.arkStatusField.innerText="Includes lifetime app updates.";this.arkCheck.disabled=false}var total=0;if(this.arkCheck.disabled===false&&this.arkCheck.checked===true){total=total+Products.Ark.Base.Price}if(this.arkSACheck.disabled===false&&this.arkSACheck.checked===true){total=total+arkSAEffectivePrice}var addToCart=this.editCartItem?"Edit":"Add to Cart";if(total>0){this.actionButton.disabled=false;this.actionButton.innerText="".concat(addToCart,": ").concat(formatCurrency(total))}else{this.actionButton.disabled=true;this.actionButton.innerText=addToCart}}};wizard.init();var cartElements={emailField:document.getElementById("storefront-cart-header-email-field"),changeEmailButton:document.getElementById("storefront-cart-header-email-button")};var goToCart=()=>{history.pushState({},"","/omni/#checkout");dispatchEvent(new PopStateEvent("popstate",{}))};var goToLanding=()=>{history.pushState({},"","/omni/");dispatchEvent(new PopStateEvent("popstate",{}))};var createProductRow=(cartItem,productId)=>{var quantity=cartItem.getQuantity(productId);if(quantity<=0){return null}var name=ProductIds[productId].Name;var price=ProductIds[productId].Price;var quantityCell=document.createElement("div");quantityCell.appendChild(document.createTextNode(quantity));var nameCell=document.createElement("div");nameCell.appendChild(document.createTextNode(name));var priceCell=document.createElement("div");priceCell.classList.add("formatted-price");priceCell.appendChild(document.createTextNode(price*quantity));var row=document.createElement("div");row.classList.add("bundle-product");row.appendChild(quantityCell);row.appendChild(nameCell);row.appendChild(priceCell);return row};var createCartItemRow=cartItem=>{var productIds=cartItem.productIds;if(productIds.length<=0){return null}var row=document.createElement("div");row.classList.add("bundle");productIds.forEach(productId=>{var productRow=createProductRow(cartItem,productId);if(productRow){row.appendChild(productRow)}});var giftCell=document.createElement("div");if(cartItem.isGift){row.classList.add("gift");giftCell.classList.add("gift");if(productIds.length>1){giftCell.appendChild(document.createTextNode("These products are a gift. You will receive a gift code for them."))}else{giftCell.appendChild(document.createTextNode("This product is a gift. You will receive a gift code for it."))}}var editButton=document.createElement("button");editButton.appendChild(document.createTextNode("Edit"));editButton.classList.add("small");editButton.addEventListener("click",ev=>{ev.preventDefault();wizard.present(cartItem)});var removeButton=document.createElement("button");removeButton.appendChild(document.createTextNode("Remove"));removeButton.classList.add("red");removeButton.classList.add("small");removeButton.addEventListener("click",ev=>{ev.preventDefault();cart.remove(cartItem);updateCart()});var actionButtons=document.createElement("div");actionButtons.classList.add("button-group");actionButtons.appendChild(editButton);actionButtons.appendChild(removeButton);var actionsCell=document.createElement("div");actionsCell.appendChild(actionButtons);var actionsRow=document.createElement("div");actionsRow.classList.add("actions");actionsRow.classList.add("double-group");actionsRow.appendChild(giftCell);actionsRow.appendChild(actionsCell);row.appendChild(actionsRow);return row};updateCart=()=>{if(cart.count>0){cartElements.emailField.innerText=cart.email;cartElements.changeEmailButton.classList.remove("hidden");cartContainer.innerText="";cartContainer.classList.remove("empty");var items=cart.items;items.forEach(cartItem=>{var bundleRow=createCartItemRow(cartItem);if(bundleRow){cartContainer.appendChild(bundleRow)}});var buttonGroup=document.createElement("div");buttonGroup.classList.add("button-group");cartElements.buyMoreButton=document.createElement("button");cartElements.buyMoreButton.addEventListener("click",ev=>{wizard.present()});cartElements.buyMoreButton.appendChild(document.createTextNode("Add More"));cartElements.checkoutButton=document.createElement("button");cartElements.checkoutButton.addEventListener("click",ev=>{var checkoutFunction=cartChanged=>{updateCart();if(cartChanged){BeaconDialog.show("Your cart contents have changed.","The items in your cart have changed based on your e-mail address. Please review before continuing checkout.");return}console.log("Checkout")};if(!cart.email){emailDialog.present(false,checkoutFunction)}else{checkoutFunction(false)}});cartElements.checkoutButton.classList.add("default");cartElements.checkoutButton.appendChild(document.createTextNode("Checkout"));buttonGroup.appendChild(cartElements.buyMoreButton);buttonGroup.appendChild(cartElements.checkoutButton);var currencyCell=document.createElement("div");currencyCell.appendChild(document.createTextNode("Currency Menu"));var buttonsCell=document.createElement("div");buttonsCell.appendChild(buttonGroup);var footer=document.createElement("div");footer.classList.add("storefront-cart-footer");footer.classList.add("double-group");footer.appendChild(currencyCell);footer.appendChild(buttonsCell);cartContainer.appendChild(footer);buyButton.innerText="Go to Cart"}else{cartElements.emailField.innerText="";cartElements.changeEmailButton.classList.add("hidden");cartElements.checkoutButton=null;cartContainer.innerText="";cartContainer.classList.add("empty");cartContainer.appendChild(document.createElement("div"));var middleCell=document.createElement("div");var firstParagraph=document.createElement("p");firstParagraph.appendChild(document.createTextNode("Your cart is empty."));middleCell.appendChild(firstParagraph);cartElements.buyMoreButton=document.createElement("button");cartElements.buyMoreButton.addEventListener("click",ev=>{emailDialog.present(true,cartChanged=>{wizard.present()})});cartElements.buyMoreButton.classList.add("default");cartElements.buyMoreButton.appendChild(document.createTextNode("Buy Omni"));var secondParagraph=document.createElement("p");secondParagraph.appendChild(cartElements.buyMoreButton);middleCell.appendChild(secondParagraph);cartContainer.appendChild(middleCell);cartContainer.appendChild(document.createElement("div"));buyButton.innerText="Buy Omni"}BeaconCurrency.formatPrices()};updateCart();var setViewMode=function(){var animated=arguments.length>0&&arguments[0]!==undefined?arguments[0]:true;window.scrollTo(window.scrollX,0);if(window.location.hash==="#checkout"){storeViewManager.switchView("page-cart",animated)}else{storeViewManager.back(animated)}};buyButton.addEventListener("click",ev=>{ev.preventDefault();if(cart.count>0){goToCart();return}emailDialog.present(true,cartChanged=>{wizard.present()})});landingButton.addEventListener("click",ev=>{goToLanding()});cartElements.changeEmailButton.addEventListener("click",ev=>{emailDialog.present(false,cartChanged=>{updateCart()})});window.addEventListener("popstate",ev=>{setViewMode(true)});setViewMode(false)});document.addEventListener("GlobalizeLoaded",()=>{updateCart()});