(function () {
  function fetchUsers(html, cb) {
    var request = new XMLHttpRequest();

    request.open("POST", "http://mentionizer.herokuapp.com/users", true);
    request.setRequestHeader(
      "Content-Type",
      "application/x-www-form-urlencoded; charset=UTF-8"
    );

    var encoded = encodeURIComponent(html);
    encoded = encoded.replace('%20','+').replace('%3D','=');
    request.send("html=" + encoded);

    request.onreadystatechange = function () {
      if (request.readyState === 4 && request.status === 200) {
        var users = JSON.parse(request.responseText);
        cb(users);
      }
    }
  }

  function fetchParams(cb) {
    fetchUsers(document.documentElement.outerHTML, function(usernames) {
      var text;

      var selection = document.getSelection().toString();
      if (selection.length) {
        text = '"' + selection + '"';
      } else {
        text = document.title;
      }

      if (usernames && usernames.length > 0) {
        mentions = []
        for (var i=0; i < usernames.length; i++) {
          mentions.push("@" + usernames[i].username);
        }
        text += " via " + mentions.join(" ");
      }

      cb(window.location.href, text);
    });
  }

  function openBuffer() {
    fetchParams(function(url, text) {
      var frame = document.createElement('iframe');

      frame.allowtransparency = 'true';
      frame.scrolling = 'no';
      frame.style.cssText = [
        'border:none;',
        'height:100%;',
        'width:100%;',
        'position:fixed!important;',
        'z-index:2147483646;',
        'top:0;',
        'left:0;',
        'display:block!important;',
        'max-width:100%!important;',
        'max-height:100%!important;',
        'padding:0!important;',
        'background:none;',
        'background-color:transparent;',
        'background-color:rgba(0, 0, 0, 0.1);'
      ].join('');

      var params = [
        "url=" + encodeURIComponent(url),
        "text=" + encodeURIComponent(text)
      ];
      var url = "https://bufferapp.com/add?" + params.join("&");

      frame.src = url;
      document.body.appendChild(frame);

      window.addEventListener("message", function (event) {
        var data = JSON.parse(event.data);
        if (event.origin == "https://bufferapp.com" && data['type'] == 'buffermessage') {
          document.body.removeChild(frame);
        }
      }, false);
    });
  }

  function openHootsuite() {
    fetchParams(function(url, text) {
      var params = [
        "address=" + encodeURIComponent(url),
        "title=" + encodeURIComponent(text)
      ];

      var url = "https://hootsuite.com/hootlet/load?" + params.join("&");
      window.open(url, 'Share', 'width=700,height=250,toolbar=0,location=0,status=0,scrollbars=yes');
    });
  }

  function openTwitter() {
    fetchParams(function(url, text) {
      var params = [
        "url=" + encodeURIComponent(url),
        "text=" + encodeURIComponent(text)
      ];

      var url = "https://twitter.com/intent/tweet?" + params.join("&");
      window.open(url, 'Share', 'width=670,height=460,toolbar=0,location=0,status=0,scrollbars=yes');
    });
  }

  function getScriptIntent() {
    var scripts = document.getElementsByTagName('script');
    var index = scripts.length - 1;
    var myScript = scripts[index];
    return myScript.getAttribute('data-intent');
  }

  var strategies = {
    twitter: openTwitter,
    hootsuite: openHootsuite,
    buffer: openBuffer
  };

  strategies[getScriptIntent()]();
})();

