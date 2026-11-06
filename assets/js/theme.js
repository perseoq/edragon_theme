(function () {
  var root = document.documentElement;

  var toggle = document.querySelector('[data-theme-toggle]');
  if (toggle) {
    toggle.addEventListener('click', function () {
      var isDark = root.classList.toggle('dark');
      try {
        localStorage.setItem('theme', isDark ? 'dark' : 'light');
      } catch (e) {}
    });
  }

  // Envuelve las tablas del contenido para que puedan hacer scroll horizontal.
  document.querySelectorAll('.prose-content table').forEach(function (table) {
    var parent = table.parentNode;
    if (!parent || (parent.classList && parent.classList.contains('table-wrapper'))) {
      return;
    }

    var wrapper = document.createElement('div');
    wrapper.className = 'table-wrapper';
    parent.insertBefore(wrapper, table);
    wrapper.appendChild(table);
  });
})();
