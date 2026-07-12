document.addEventListener('DOMContentLoaded', function () {
  if (window.jQuery && typeof window.jQuery.fn.lavaLamp === 'function') {
    window.jQuery('.lavaLamp').lavaLamp({ fx: 'backout', speed: 700 });
  }
});
