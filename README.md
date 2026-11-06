# Blog Jekyll + Tailwind CSS

Plantilla de blog personal para **GitHub Pages**. Incluye Jekyll 4, Tailwind CSS 4,
modo claro/oscuro, paginación, barra lateral automática, menú editable desde Markdown
y resaltado de sintaxis con el tema Monokai Pro.

## Cómo usar esta plantilla

1. Pulsa **Use this template → Create a new repository** en GitHub.
   También puedes usar la CLI:

   ```bash
   gh repo create mi-blog --template perseoq/edragon_theme --public
   ```

2. Clona tu repo nuevo:

   ```bash
   git clone https://github.com/TU-USUARIO/mi-blog.git
   cd mi-blog
   ```

3. Edita `_config.yml` con tus datos (`title`, `description`, `email`, `lang`).

4. En GitHub ve a **Settings → Pages → Build and deployment → Source** y elige
   **GitHub Actions**.

5. Haz push a `main`. El workflow
   [`.github/workflows/pages.yml`](.github/workflows/pages.yml) compila Tailwind y
   Jekyll y publica el sitio.

   > Si es tu primer workflow, GitHub puede pedirte que confirmes la ejecución de
   > Actions. Revisa la pestaña **Actions** del repo.

6. Abre `https://TU-USUARIO.github.io/mi-blog/` (o
   `https://TU-USUARIO.github.io/` si el repo se llama `TU-USUARIO.github.io`).

### Checklist después de crear el repo

- [ ] Editar `_config.yml`.
- [ ] Activar Pages con origen **GitHub Actions**.
- [ ] Reemplazar el post de ejemplo en `_posts/`.
- [ ] Editar `pages/sobre-mi.md` y `pages/contacto.md` (o borrarlas).
- [ ] Ajustar el menú en `nav/menu.md`.
- [ ] Subir el primer commit a `main`.

## Desarrollo local

Requisitos: Ruby 4.0 o superior, Bundler 4, Node.js 22 o superior.

```bash
bundle install
npm ci
npm run serve
```

El sitio queda en `http://localhost:4000`.

Otros comandos:

```bash
npm run build:css   # compila Tailwind a assets/css/main.css
npm run build       # compila CSS + sitio Jekyll en _site/
```

> `assets/css/main.css` está versionado para que el sitio funcione aunque no
> ejecutes npm, pero Tailwind lo regenera en cada build. Si cambias clases de
> Tailwind en layouts, includes o contenido, ejecuta `npm run build:css`.

## Publicación

El workflow usa `actions/configure-pages` y calcula automáticamente `url` y
`baseurl` según el tipo de repo:

- Repo de usuario/organización (`usuario.github.io`): `baseurl` vacío.
- Repo de proyecto (`usuario.github.io/mi-blog/`): `baseurl: /mi-blog`.

Por eso los enlaces de la plantilla usan `relative_url` (y el menú se prefija con
`site.baseurl`), y no hace falta tocar `baseurl` a mano.

## Estructura

```
.
├── _config.yml            # Configuración del sitio
├── _layouts/              # default, home, page y post
├── _includes/             # head, header, footer, sidebar, paginación, preview
├── _posts/                # Entradas del blog (YYYY-MM-DD-titulo.md)
├── pages/                 # Páginas sueltas (aparecen en la barra lateral)
├── nav/menu.md            # Menú superior (lista Markdown)
├── assets/
│   ├── css/main.css       # CSS compilado por Tailwind (versionado)
│   └── js/theme.js        # Toggle de modo claro/oscuro
├── src/
│   ├── tailwind.css       # Fuente de Tailwind
│   └── syntax-monokai-pro.css
└── index.html             # Portada con paginación
```

## Añadir contenido

### Una entrada

Crea `_posts/2026-11-10-mi-entrada.md`:

```markdown
---
layout: post
title: "Mi entrada"
date: 2026-11-10 10:00:00 -0600
categories: notas
---

Contenido en Markdown.
```

### Una página

Crea `pages/proyectos.md` y aparecerá automáticamente en la barra lateral:

```markdown
---
layout: page
title: Proyectos
permalink: /pages/proyectos/
---

Contenido de la página.
```

Para ocultarla de la barra lateral añade `sidebar: false` al front matter.

### El menú

`nav/menu.md` es una lista Markdown normal. Los enlaces que empiezan por `/` se
publican con el `baseurl` correcto de forma automática:

```markdown
---
title: Menú
---

- [Inicio](/)
- [Sobre mí](/pages/sobre-mi/)
- [Contacto](/pages/contacto/)
```

## Personalización

- **Colores y tipografía**: `src/tailwind.css` (bloque `@theme`).
- **Layout**: `_layouts/default.html`.
- **Cabecera, pie y barra lateral**: `_includes/`.
- **Tema de código**: `src/syntax-monokai-pro.css`.

Después de cambiar `src/tailwind.css` o clases de Tailwind, ejecuta
`npm run build:css` y commitea `assets/css/main.css`.

## Notas sobre GitHub Pages

- Un repositorio plantilla copia **solo archivos**: no se heredan Pages, secretos,
  environments ni permisos de Actions. Cada repo nuevo debe configurar Pages.
- El repo plantilla debe ser público para que cualquiera pueda usarlo (y para
  publicar Pages en el plan gratuito).
- Si el workflow falla por permisos, revisa **Settings → Actions → General →
  Workflow permissions**.

## Licencia

Añade la licencia que prefieras antes de publicar tu versión de la plantilla.
