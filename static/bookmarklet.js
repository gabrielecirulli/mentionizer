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

  var CONTAINER_CSS = {
    border:          'none',
    height:          '100%',
    width:           '100%',
    position:        'fixed',
    zIndex:          '2147483646',
    top:             '0',
    left:            '0',
    display:         'block',
    maxWidth:        '100%',
    maxHeight:       '100%',
    padding:         '0',
    backgroundColor: 'rgba(0, 0, 0, 0.1)',
    fontFamily:      '"HelveticaNeue-Light", "Helvetica Neue Light", "Helvetica Neue", Helvetica, Arial, "Lucida Grande", sans-serif',
    fontWeight:      300
  }

  var CSS_ANIMATIONS = [
    '@-webkit-keyframes mentionizerRotateplane {',
    '  0% { -webkit-transform: perspective(120px) }',
    '  50% { -webkit-transform: perspective(120px) rotateY(180deg) }',
    '  100% { -webkit-transform: perspective(120px) rotateY(180deg)  rotateX(180deg) }',
    '}',
    '@keyframes mentionizerRotateplane {',
    '  0% {',
    '    transform: perspective(120px) rotateX(0deg) rotateY(0deg);',
    '    -webkit-transform: perspective(120px) rotateX(0deg) rotateY(0deg);',
    '  } 50% {',
    '    transform: perspective(120px) rotateX(-180.1deg) rotateY(0deg);',
    '    -webkit-transform: perspective(120px) rotateX(-180.1deg) rotateY(0deg);',
    '  } 100% {',
    '    transform: perspective(120px) rotateX(-180deg) rotateY(-179.9deg);',
    '    -webkit-transform: perspective(120px) rotateX(-180deg) rotateY(-179.9deg);',
    '  }',
    '}'
  ].join("\n");

  function applyCss(element, rules) {
    Object.keys(rules).forEach(function(rule) {
      element.style[rule] = rules[rule];
    });
  }

  function fetchParams(cb) {
    var keyframeContainer = document.createElement('style');
    keyframeContainer.textContent = CSS_ANIMATIONS;
    document.head.appendChild(keyframeContainer);

    var container = document.createElement('div');
    applyCss(container, CONTAINER_CSS);
    applyCss(container, {
      display: 'table'
    });

    var wrapper = document.createElement('div');
    applyCss(wrapper, {
      display:       'table-cell',
      verticalAlign: 'middle',
      textAlign:     'center'
    });
    container.appendChild(wrapper);

    var loading = document.createElement('div');
    applyCss(loading, {
       width:           '60px',
       height:          '60px',
       backgroundColor: '#29A9E0',
       margin:          '0 auto',
       WebkitAnimation: 'mentionizerRotateplane 1.2s infinite ease-in-out',
       animation:       'mentionizerRotateplane 1.2s infinite ease-in-out'
    });
    wrapper.appendChild(loading);

    document.body.appendChild(container);

    fetchUsers(document.documentElement.outerHTML, function(usernames) {
      var text;

      var selection = document.getSelection().toString();
      if (selection.length) {
        text = '"' + selection + '"';
      } else {
        text = document.title;
      }

      if (usernames) {
        mentions = []
        usernames.forEach(function(user) {
          mentions.push("@" + user.username);
        });
        text += " via " + mentions.join(" ");
      }

      cb(window.location.href, text);

      document.body.removeChild(container);
    });
  }

  function generateOpenerButton(text, bgcolor, url, width, height) {
    var container = document.createElement('div');
    applyCss(container, CONTAINER_CSS);
    applyCss(container, {
      display: 'table'
    });

    container.addEventListener('click', function() {
      document.body.removeChild(container);
    });

    var wrapper = document.createElement('div');
    applyCss(wrapper, {
      display:       'table-cell',
      verticalAlign: 'middle',
      textAlign:     'center'
    });
    container.appendChild(wrapper);

    var button = document.createElement('a');
    button.setAttribute('href', 'javascript:void(0)');
    button.textContent = text;
    applyCss(button, {
      padding:            '20px 30px',
      color:              '#fff',
      fontSize:           '20px',
      textDecoration:     'none',
      borderRadius:       '3px',
      mozBorderRadius:    '3px',
      webkitBorderRadius: '3px',
      backgroundColor:    bgcolor
    });
    button.addEventListener('click', function() {
      window.open(url, 'Share', 'width=' + width + ',height=' + height + ',toolbar=0,location=0,status=0,scrollbars=yes');
    });
    wrapper.appendChild(button);

    document.body.appendChild(container);
  }

  function openBuffer() {
    fetchParams(function(url, text) {
      var frame = document.createElement('iframe');

      frame.allowtransparency = 'true';
      frame.scrolling = 'no';
      applyCss(frame, CONTAINER_CSS);

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
      generateOpenerButton('Share with Hootsuite', '#424A55', url, 700, 250);
    });
  }

  function openTwitter() {
    fetchParams(function(url, text) {
      var params = [
        "url=" + encodeURIComponent(url),
        "text=" + encodeURIComponent(text)
      ];

      var url = "https://twitter.com/intent/tweet?" + params.join("&");
      generateOpenerButton('Share on Twitter', '#29A9E0', url, 670, 460);
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

