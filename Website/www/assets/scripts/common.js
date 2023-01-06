if (!String.prototype.endsWith) {
	String.prototype.endsWith = function(search, this_len) {
		if (this_len === undefined || this_len > this.length) {
			this_len = this.length;
		}
		return this.substring(this_len - search.length, this_len) === search;
	};
}

if (!('randomUUID' in crypto))
  // https://stackoverflow.com/a/2117523/2800218
  // LICENSE: https://creativecommons.org/licenses/by-sa/4.0/legalcode
  crypto.randomUUID = function randomUUID() {
	return (
	  [1e7]+-1e3+-4e3+-8e3+-1e11).replace(/[018]/g,
	  c => (c ^ crypto.getRandomValues(new Uint8Array(1))[0] & 15 >> c / 4).toString(16)
	);
  };

// Deprecated
var request = {
	start: function(method, uri, content_type, entity_body, success_handler, error_handler, headers) {
		var xhr = new XMLHttpRequest();
		xhr.open(method, uri, true);
		xhr.setRequestHeader('Accept', 'application/json');
		if (content_type != '') {
			xhr.setRequestHeader('Content-Type', content_type);
		}
		if (headers !== null) {
			for (var key in headers) {
				xhr.setRequestHeader(key, headers[key]);
			}
		}
		xhr.onreadystatechange = function() {
			if (xhr.readyState != 4) {
				return;
			}
			
			if (xhr.status < 200 || xhr.status >= 300) {
				error_handler(xhr.status, xhr.responseText);
				return;
			}
			
			var obj
			if (xhr.responseText != '') {
				obj = JSON.parse(xhr.responseText);
			} else {
				obj = {};
			}
			success_handler(obj);
		};
		xhr.send(entity_body);
	},
	get: function(uri, formdata, success_handler, error_handler, headers) {
		var query = this.encodeFormData(formdata);
		if (query != '') {
			query = '?' + query;
		}
		this.start('GET', uri + query, '', '', success_handler, error_handler, headers);
	},
	post: function(uri, formdata, success_handler, error_handler, headers) {
		this.start('POST', uri, 'application/x-www-form-urlencoded', this.encodeFormData(formdata), success_handler, error_handler, headers);
	},
	encodeFormData: function(formdata) {
		if (formdata === null) {
			return '';
		} else if (formdata === undefined) {
			return '';
		} else if (formdata.constructor === {}.constructor) {
			var pairs = [];
			for (var key in formdata) {
				pairs.push(encodeURIComponent(key) + '=' + encodeURIComponent(formdata[key]));
			}
			return pairs.join('&');
		} else {
			return '';
		}
	}
};

// Deprecated
var dialog = {
	show: function(message, explanation, handler) {
		var overlay = document.getElementById('overlay');
		var dialog_frame = document.getElementById('dialog');
		var dialog_message = document.getElementById('dialog_message');
		var dialog_explanation = document.getElementById('dialog_explanation');
		var dialog_action_button = document.getElementById('dialog_action_button');
		var dialog_cancel_button = document.getElementById('dialog_cancel_button');
		if (overlay && dialog && dialog_message && dialog_explanation && dialog_action_button && dialog_cancel_button) {
			overlay.className = 'exist';
			dialog_frame.className = 'exist';
			setTimeout(function() {
				overlay.className = 'exist visible';
				dialog_frame.className = 'exist visible';
			}, 10);
			dialog_message.innerText = message;
			dialog_explanation.innerText = explanation;
			dialog_action_button.addEventListener('click', function(event) {
				event.target.removeEventListener(event.type, arguments.callee);
				dialog.hide(handler);
			});
			dialog_cancel_button.className = 'hidden';
			dialog_action_button.innerText = 'Ok';
		}
	},
	confirm: function(message, explanation, action_caption, cancel_caption, handler) {
		let prom = new Promise((resolve, reject) => {
			let overlay = document.getElementById('overlay');
			let dialog_frame = document.getElementById('dialog');
			let dialog_message = document.getElementById('dialog_message');
			let dialog_explanation = document.getElementById('dialog_explanation');
			let dialog_action_button = document.getElementById('dialog_action_button');
			let dialog_cancel_button = document.getElementById('dialog_cancel_button');
			if (overlay && dialog && dialog_message && dialog_explanation && dialog_action_button && dialog_cancel_button) {
				overlay.className = 'exist';
				dialog_frame.className = 'exist';
				setTimeout(function() {
					overlay.className = 'exist visible';
					dialog_frame.className = 'exist visible';
				}, 10);
				dialog_message.innerText = message;
				dialog_explanation.innerText = explanation;
				dialog_action_button.addEventListener('click', function(event) {
					event.target.removeEventListener(event.type, arguments.callee);
					dialog.hide(resolve);
				});
				dialog_cancel_button.addEventListener('click', function(event) {
					event.target.removeEventListener(event.type, arguments.callee);
					dialog.hide(reject);
				});
				dialog_cancel_button.className = '';
				dialog_action_button.innerText = action_caption;
				dialog_cancel_button.innerText = cancel_caption;
			}
		});
		
		if (handler) {
			prom.then(handler).catch(function() {});
		} else {
			return prom;
		}
	},
	hide: function(handler) {
		var overlay = document.getElementById('overlay');
		var dialog_frame = document.getElementById('dialog');
		if (overlay && dialog_frame) {
			overlay.className = 'exist';
			dialog_frame.className = 'exist';
			setTimeout(function() {
				overlay.className = '';
				dialog_frame.className = '';
				if (handler) {
					handler();
				}
			}, 300);
		}
	},
	showModal: function(id) {
		BeaconDialog.showModal(id);
	},
	hideModal: function(id) {
		BeaconDialog.hideModal();
	}
};

class BeaconWebRequest {
	static prepareResponse(xhr) {
		return {
			xhr: xhr,
			status: xhr.status,
			statusText: xhr.statusText,
			body: xhr.responseText,
			success: (xhr.status >= 200 && xhr.status < 300)
		};
	}
	
	static start(method, url, body = null, headers = {}) {
		return new Promise((resolve, reject) => {
			const xhr = new XMLHttpRequest();
			xhr.open(method, url, true);
			if (typeof headers === 'object' && headers !== null && Array.isArray(headers) === false) {
				const keys = Object.keys(headers);
				for (const key of keys) {
					xhr.setRequestHeader(key, headers[key]);
				}
			}
			xhr.onload = () => {
				const response = this.prepareResponse(xhr);
				if (response.success) {
					resolve(response);
				} else {
					reject(response);
				}
			};
			xhr.onerror = () => {
				reject(this.prepareResponse(xhr));
			};
			xhr.send(body);
		});
	}
	
	static get(url, headers = {}) {
		return BeaconWebRequest.start('GET', url, null, headers);
	}
	
	static post(url, body, headers = {}) {
		if (body instanceof URLSearchParams) {
			headers['Content-Type'] = 'application/x-www-form-urlencoded';
			return BeaconWebRequest.start('POST', url, body.toString(), headers);
		} else if ((typeof body === 'object' && body !== null) || Array.isArray(body)) {
			headers['Content-Type'] = 'application/json';
			return BeaconWebRequest.start('POST', url, JSON.stringify(body), headers);
		} else {
			return BeaconWebRequest.start('POST', url, body, headers);
		}
	}
	
	static delete(url, headers = {}) {
		return BeaconWebRequest.start('DELETE', url, null, headers);
	}
}

class BeaconDialog {
	static activeModal = null;
	
	static show(message, explanation, actionCaption = 'Ok') {
		return BeaconDialog.confirm(message, explanation, actionCaption, null);
	}
	
	static confirm(message, explanation, actionCaption = 'Ok', cancelCaption = 'Cancel') {
		return new Promise((resolve, reject) => {
			const overlay = document.getElementById('overlay');
			const dialogFrame = document.getElementById('dialog');
			const dialogMessage = document.getElementById('dialog_message');
			const dialogExplanation = document.getElementById('dialog_explanation');
			const dialogActionButton = document.getElementById('dialog_action_button');
			const dialogCancelButton = document.getElementById('dialog_cancel_button');
			
			if (!(overlay && dialogFrame && dialogMessage && dialogExplanation && dialogActionButton && dialogCancelButton)) {
				reject();
				return;
			}
			
			overlay.className = 'exist';
			dialogFrame.className = 'exist';
			setTimeout(() => {
				overlay.className = 'exist visible';
				dialogFrame.className = 'exist visible';
			}, 10);
			dialogMessage.innerText = message;
			dialogExplanation.innerText = explanation;
			
			if (dialogActionButton.clickHandler) {
				dialogActionButton.removeEventListener('click', dialogActionButton.clickHandler);
			}
			if (dialogCancelButton.clickHandler) {
				dialogCancelButton.removeEventListener('click', dialogCancelButton.clickHandler);
			}
			
			dialogActionButton.clickHandler = (event) => {
				BeaconDialog.hide();
				setTimeout(() => {
					resolve();
				}, 300);
			};
			dialogActionButton.addEventListener('click', dialogActionButton.clickHandler);
			dialogActionButton.innerText = actionCaption;
			
			if (cancelCaption) {
				dialogCancelButton.clickHandler = (event) => {
					BeaconDialog.hide();
					setTimeout(() => {
						reject();
					}, 300);
				};
				dialogCancelButton.addEventListener('click', dialogCancelButton.clickHandler);
				dialogCancelButton.innerText = cancelCaption;
			} else {
				dialogCancelButton.className = 'hidden';
			}
		});
	}
	
	static hide() {
		var overlay = document.getElementById('overlay');
		var dialogFrame = document.getElementById('dialog');
		if (!(overlay && dialogFrame)) {
			return;
		}
		overlay.className = 'exist';
		dialogFrame.className = 'exist';
		setTimeout(() => {
			overlay.className = '';
			dialogFrame.className = '';
		}, 300);
	}
	
	static showModal(elementId) {
		if (BeaconDialog.activeModal) {
			return;
		}
		
		const overlay = document.getElementById('overlay');
		const modal = document.getElementById(elementId);
		if (!(overlay && modal)) {
			return;
		}
		
		overlay.classList.add('exist');
		modal.classList.add('exist');
		BeaconDialog.activeModal = elementId;
		
		setTimeout(() => {
			overlay.classList.add('visible');
			modal.classList.add('visible');
		}, 10);
	}
	
	static hideModal() {
		if (!BeaconDialog.activeModal) {
			return;
		}
		
		const overlay = document.getElementById('overlay');
		const modal = document.getElementById(BeaconDialog.activeModal);
		if (!(overlay && modal)) {
			return;
		}
		
		overlay.classList.remove('visible');
		modal.classList.remove('visible');
		
		setTimeout(function() {
			overlay.classList.remove('exist');
			modal.classList.remove('exist');
			BeaconDialog.activeModal = null;
		}, 300);
	}
}
