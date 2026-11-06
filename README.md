# Blog Jekyll + Tailwind CSS

Tema de blog personal para **GitHub Pages**. Incluye Jekyll 4, Tailwind CSS 4,
modo claro/oscuro, paginación, barra lateral automática, menú editable desde Markdown
y resaltado de sintaxis con el tema Monokai Pro.

Se puede usar de dos formas:

- **Como tema remoto (`remote_theme`)** — recomendado: tu repositorio solo guarda
  el contenido y Jekyll trae los layouts, includes y assets desde este repo.
- **Como plantilla completa** — copias todo el sitio y puedes modificar el tema.

## Usar como tema remoto (recomendado)

No copies el sitio. Crea un repositorio nuevo (o usa uno existente) y añade solo
tu contenido y la configuración.

### 1. `_config.yml`

```yaml
title: Mi blog
description: Mi blog personal
lang: es

# Tema remoto
remote_theme: perseoq/edragon_theme

plugins:
  - jekyll-remote-theme
  - jekyll-feed
  - jekyll-paginate

# Paginación de la portada
paginate: 5
paginate_path: "/page:num/"
```

No copies el `_config.yml` de este repositorio: en un tema remoto el que manda es
el de tu sitio.

### 2. `Gemfile`

Solo es necesario si publicas con **GitHub Actions**:

```ruby
source "https://rubygems.org"

gem "jekyll", "~> 4.4.1"

group :jekyll_plugins do
  gem "jekyll-remote-theme"
  gem "jekyll-feed", "~> 0.12"
  gem "jekyll-paginate", "~> 1.1"
end
```

Ejecuta `bundle install` y commitea el `Gemfile.lock` generado.

Si publicas con **Deploy from a branch**, GitHub Pages ya incluye
`jekyll-remote-theme`, `jekyll-feed` y `jekyll-paginate`, así que no necesitas
`Gemfile` ni workflow.

Añade también un `.gitignore` para no versionar artefactos:

```gitignore
_site
.jekyll-cache
.jekyll-metadata
_config.pages.yml
vendor
```

### 3. `index.html`

```html
---
layout: home
title: Inicio
---
```

`layout: home` es obligatorio en la portada: es el layout que muestra la lista de
posts y la paginación.

### 4. Contenido

Crea solo lo que necesites:

```
_posts/2026-11-10-mi-entrada.md   # entradas del blog
pages/sobre-mi.md                # páginas (aparecen en la barra lateral)
nav/menu.md                      # menú superior (opcional)
assets/                          # tus propios CSS/JS/imágenes (opcional)
```

Ejemplo de `nav/menu.md`:

```markdown
---
title: Menú
---

- [Inicio](/)
- [Sobre mí](/pages/sobre-mi/)
```

Los enlaces que empiezan por `/` reciben el `baseurl` automáticamente.

Un post mínimo en `_posts/2026-11-10-mi-entrada.md`:

```markdown
---
layout: post
title: "Mi entrada"
date: 2026-11-10 10:00:00 -0600
---

Contenido en Markdown.
```

### 5. Publicar

#### Opción A: GitHub Actions (recomendado)

Crea `.github/workflows/pages.yml`:

```yaml
name: Deploy Jekyll site to GitHub Pages

on:
  push:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: pages
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: "3.3"
          bundler-cache: true

      - id: pages
        uses: actions/configure-pages@v5

      - name: Build with Jekyll
        env:
          JEKYLL_ENV: production
        run: |
          printf 'url: "%s"\nbaseurl: "%s"\n' \
            "${{ steps.pages.outputs.origin }}" \
            "${{ steps.pages.outputs.base_path }}" > _config.pages.yml
          bundle exec jekyll build --config _config.yml,_config.pages.yml

      - uses: actions/upload-pages-artifact@v3
        with:
          path: _site

  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - id: deployment
        uses: actions/deploy-pages@v4
```

Después ve a **Settings → Pages → Build and deployment → Source** y elige
**GitHub Actions**. Haz push a `main` y revisa la pestaña **Actions**.

#### Opción B: Deploy from a branch

En **Settings → Pages → Source** elige **Deploy from a branch**, la rama `main` y
la carpeta `/ (root)`. GitHub Pages compila Jekyll y soporta `remote_theme`
(además `jekyll-feed` y `jekyll-paginate` vienen incluidos).

En este caso configura el `baseurl` a mano en `_config.yml`:

```yaml
# Sitio de usuario: https://usuario.github.io/
url: "https://usuario.github.io"
baseurl: ""

# Sitio de proyecto: https://usuario.github.io/mi-blog/
# url: "https://usuario.github.io"
# baseurl: "/mi-blog"
```

### Cómo funciona el tema remoto

- Jekyll descarga este repositorio en cada build y usa `_layouts/`, `_includes/`,
  `assets/` y `_data/` (si existe). El `_config.yml`, `_posts/`, `pages/` y
  `nav/` de este repo **no** se usan en tu sitio.
- El CSS de Tailwind ya viene compilado en `assets/css/main.css`; no necesitas
  Node.js ni ejecutar npm.
- Puedes sobrescribir cualquier archivo del tema creando uno con la misma ruta en
  tu repo. Por ejemplo, `_layouts/post.html` o `_includes/footer.html`.
- `jekyll-feed` es obligatorio: el layout usa `{% raw %}{% feed_meta %}{% endraw %}`.
  `jekyll-paginate` es opcional, pero sin él no habrá páginas `/page2/`.

### Fijar una versión y actualizar

Sin sufijo, `remote_theme` usa la última versión de `main`:

```yaml
remote_theme: perseoq/edragon_theme
```

Para fijar una versión concreta usa un commit (o un tag, si publicas releases):

```yaml
remote_theme: perseoq/edragon_theme@abc1234
# o, si existe el tag:
remote_theme: perseoq/edragon_theme@v1.0.0
```

Como el tema se descarga en cada build, los cambios publicados en
`perseoq/edragon_theme` se aplican la próxima vez que se reconstruya tu sitio. Si
prefieres estabilidad, fija un commit o tag.

> Si el repositorio del tema es privado, GitHub Pages necesita un token para
> descargarlo. Lo más sencillo es mantener el tema público.

## Usar como plantilla completa (alternativa)

Si quieres modificar el tema (layouts, Tailwind, etc.), copia todo el sitio:

1. Entra en <https://github.com/perseoq/edragon_theme> y pulsa
   **Use this template → Create a new repository**, o usa la CLI:

   ```bash
   gh repo create mi-blog --template perseoq/edragon_theme --public
   ```

2. Clona tu repo, edita `_config.yml` y activa Pages con origen
   **GitHub Actions**.
3. El workflow incluido compila Tailwind y Jekyll automáticamente.

En este modo el repositorio es tuyo: puedes cambiar `_layouts/`, `_includes/`,
`src/tailwind.css`, etc. No recibes actualizaciones automáticas del tema original.

## Desarrollo local del tema

Requisitos: Ruby 4.0 o superior, Bundler 4, Node.js 22 o superior.

```bash
git clone https://github.com/perseoq/edragon_theme.git
cd edragon_theme
bundle install
npm ci
npm run serve
```

El sitio de demostración queda en `http://localhost:4000`.

Otros comandos:

```bash
npm run build:css   # compila Tailwind a assets/css/main.css
npm run build       # compila CSS + sitio Jekyll en _site/
```

> `assets/css/main.css` está versionado para que el tema funcione sin npm. Si
> cambias clases de Tailwind en layouts, includes o contenido, ejecuta
> `npm run build:css` y commitea el resultado.

## Estructura

```
.
├── _config.yml            # Configuración del sitio de demostración
├── _layouts/              # default, home, page y post
├── _includes/             # head, header, footer, sidebar, paginación, preview
├── _posts/                # Entradas de ejemplo
├── pages/                 # Páginas de ejemplo (barra lateral)
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

> En modo `remote_theme` el CSS viene ya compilado. Si necesitas clases de
> Tailwind que no estén en el tema, añade tu propio CSS en `assets/` o usa la
> plantilla completa para recompilar `src/tailwind.css`.

## Notas sobre GitHub Pages

- Un repositorio plantilla copia **solo archivos**: no se heredan Pages, secretos,
  environments ni permisos de Actions. Cada repo nuevo debe configurar Pages.
- El repo del tema debe ser público para que cualquiera pueda usarlo (y para
  publicar Pages en el plan gratuito).
- Si el workflow falla por permisos, revisa **Settings → Actions → General →
  Workflow permissions**.
- Si usas `master` en vez de `main`, renómbralo en **Settings → Branches** o
  cambia `branches: [main]` en el workflow.

## Licencia

Añade la licencia que prefieras antes de publicar tu versión de la plantilla.
