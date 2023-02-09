"use strict";

document.addEventListener('DOMContentLoaded', () => {
  var rows = document.getElementsByClassName('beacon-engram');
  for (var row of rows) {
    var links = row.getElementsByClassName('beacon-engram-copy');
    if (links.length !== 1) {
      continue;
    }
    links[0].addEventListener('click', event => {
      var uuid = event.target.getAttribute('beacon-uuid');
      var row = document.getElementById('spawn_' + uuid);
      if (!row) {
        console.log("Row ".concat(uuid, " was not found"));
        return;
      }
      try {
        clipboard.writeText(row.getAttribute('beacon-spawn-code'));
        event.target.innerText = 'Copied!';
        event.target.disabled = true;
        setTimeout(() => {
          event.target.innerText = 'Copy';
          event.target.disabled = false;
        }, 3000);
      } catch (err) {
        alert('Looks like this browser does not support automatic copy. You will need to do it yourself.');
      }
    });
  }
});