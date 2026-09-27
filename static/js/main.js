/* Load and play the demo clips only once they scroll into view, and pause them
   again on the way out. Keeps the first paint cheap and the fans quiet. */
(function () {
  'use strict';
  var videos = Array.prototype.slice.call(document.querySelectorAll('video[data-src]'));
  if (!videos.length) return;

  function load(v) {
    if (v.dataset.loaded) return;
    v.dataset.loaded = '1';
    v.src = v.dataset.src;
  }

  if (!('IntersectionObserver' in window)) {
    videos.forEach(function (v) { load(v); v.play().catch(function () {}); });
    return;
  }

  var io = new IntersectionObserver(function (entries) {
    entries.forEach(function (e) {
      var v = e.target;
      if (e.isIntersecting) {
        load(v);
        v.play().catch(function () {});   // autoplay may be refused; poster stays
      } else if (!v.paused) {
        v.pause();
      }
    });
  }, { rootMargin: '200px 0px', threshold: 0.1 });

  videos.forEach(function (v) { io.observe(v); });
}());
