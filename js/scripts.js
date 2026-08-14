$(document).ready(function() {
	// Cache selectors
	var lastId,
	    topMenu = $("#top-menu"),
	    topMenuHeight = topMenu.outerHeight()+15,
	    // All list items
	    menuItems = topMenu.find("a"),
	    // Anchors corresponding to menu items
	    scrollItems = menuItems.map(function(){
	      var item = $($(this).attr("href"));
	      if (item.length) { return item; }
	    });

	// Bind click handler to menu items
	// so we can get a fancy scroll animation
	menuItems.click(function(e){
	  var href = $(this).attr("href"),
	      offsetTop = href === "#" ? 0 : $(href).offset().top-topMenuHeight+1;
	  $('html, body').stop().animate({ 
	      scrollTop: offsetTop
	  }, 300);
	  e.preventDefault();
	});

	// Bind to scroll
	$(window).scroll(function(){
	   // Get container scroll position
	   var fromTop = $(this).scrollTop()+topMenuHeight;
	   
	   // Get id of current scroll item
	   var cur = scrollItems.map(function(){
	     if ($(this).offset().top < fromTop)
	       return this;
	   });
	   // Get the id of the current element
	   cur = cur[cur.length-1];
	   var id = cur && cur.length ? cur[0].id : "";
	   
	   if (lastId !== id) {
	       lastId = id;
	       // Set/remove active class
	       menuItems
	         .parent().removeClass("active")
	         .end().filter("[href=#"+id+"]").parent().addClass("active");
	   }                   
	});
});
$(function() {  
    var pull        = $('#pull');  
        menu        = $('#top-menu');  
        menuHeight  = menu.height();  
  
    $(pull).on('click', function(e) {  
        e.preventDefault();  
        menu.slideToggle();  
    });  
});  
$(window).resize(function(){  
    var w = $(window).width();  
    if(w > 320 && menu.is(':hidden')) {  
        menu.removeAttr('style');  
    }  
});

(function includePartials() {
  var scripts = document.getElementsByTagName("script");
  var root = "";
  for (var i = 0; i < scripts.length; i++) {
    var src = scripts[i].src || "";
    if (src.indexOf("js/scripts.js") !== -1) {
      root = src.replace(/js\/scripts\.js.*$/, "");
      break;
    }
  }
  function rewrite(html) {
    return html.replace(/\b(src|href)="(?!https?:|mailto:|\/\/|#|\/)([^"]*)"/g, function (_, attr, url) {
      return attr + '="' + root + url + '"';
    });
  }
  function inject() {
    var map = window.__siteIncludes || {};
    var nodes = document.querySelectorAll("[data-include]");
    Array.prototype.forEach.call(nodes, function (el) {
      var name = el.getAttribute("data-include");
      var html = map[name];
      if (html) {
        el.outerHTML = rewrite(html);
      } else {
        el.innerHTML = "Unable to load " + name + ".";
      }
    });
  }
  function run() {
    if (window.__siteIncludes) {
      inject();
      return;
    }
    var s = document.createElement("script");
    s.src = root + "includes/chrome.js";
    s.onload = inject;
    s.onerror = function () {
      var nodes = document.querySelectorAll("[data-include]");
      Array.prototype.forEach.call(nodes, function (el) {
        el.innerHTML = "Unable to load " + el.getAttribute("data-include") + ".";
      });
    };
    document.head.appendChild(s);
  }
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", run);
  } else {
    run();
  }
})();

(function youtubeLocalFallback() {
  function swap() {
    if (location.protocol !== "file:") return;
    var frames = document.querySelectorAll('iframe[src*="youtube.com/embed"], iframe[src*="youtube-nocookie.com/embed"]');
    Array.prototype.forEach.call(frames, function (frame) {
      var match = frame.src.match(/embed\/([^?&]+)/);
      if (!match) return;
      var id = match[1];
      var link = document.createElement("a");
      link.href = "https://www.youtube.com/watch?v=" + id;
      link.target = "_blank";
      link.rel = "noopener noreferrer";
      link.className = "youtube-fallback";
      link.innerHTML = '<img src="https://img.youtube.com/vi/' + id + '/hqdefault.jpg" alt="Watch on YouTube">';
      frame.parentNode.replaceChild(link, frame);
    });
  }
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", swap);
  } else {
    swap();
  }
})();
