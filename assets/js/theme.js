(function () {
  var root = document.documentElement;
  var toggle = document.querySelector('[data-theme-toggle]');
  if (!toggle) return;

  toggle.addEventListener('click', function () {
    var isDark = root.classList.toggle('dark');
    try {
      localStorage.setItem('theme', isDark ? 'dark' : 'light');
    } catch (e) {}
  });
})();
