# frozen_string_literal: true

# Permite que cualquier archivo .md/.markdown/.html dentro de _posts/ sea una
# entrada, sin exigir el formato AAAA-MM-DD-titulo.md de Jekyll.
#
# La entrada se reconoce por su front matter:
#
#   ---
#   title: Un perrito sordo
#   date: 2026-11-05 10:00:00 -0600
#   tags: [perros, historias]
#   author: edragon        # opcional
#   ---
#
# Los archivos con el formato clásico siguen funcionando igual.
module Jekyll
  class FlexiblePostFilenames < Generator
    safe true
    priority :highest

    EXTENSIONS = %w[.md .markdown .html].freeze

    def generate(site)
      posts_dir = site.in_source_dir("_posts")
      return unless File.directory?(posts_dir)

      known_paths = site.posts.docs.map(&:path)

      Dir.glob(File.join(posts_dir, "**", "*")).sort.each do |path|
        next unless File.file?(path)
        next unless EXTENSIONS.include?(File.extname(path).downcase)
        next if known_paths.include?(path)

        document = Jekyll::Document.new(
          path,
          :site       => site,
          :collection => site.posts
        )
        document.read

        # Sin fecha, usamos la fecha del archivo para que el orden sea estable.
        unless document.data.key?("date")
          document.data["date"] = File.mtime(path)
          Jekyll.logger.warn(
            "Posts:",
            "#{document.relative_path} no tiene 'date'; usando la fecha del archivo"
          )
        end

        next unless site.publisher.publish?(document)

        site.posts.docs << document
        known_paths << path
      end

      site.posts.docs.sort_by!(&:date)
    end
  end
end
