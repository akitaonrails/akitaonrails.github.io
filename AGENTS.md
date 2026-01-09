# AGENTS.md - AkitaOnRails Blog

This is a Hugo static site using the [Hextra](https://github.com/imfing/hextra) theme, hosting Fabio Akita's personal blog at [akitaonrails.com](https://www.akitaonrails.com/).

## Quick Reference

| Action | Command |
|--------|---------|
| Start dev server (Docker) | `./scripts/dev.sh start` |
| Start dev server (local) | `hugo server --logLevel debug --disableFastRender -p 1313` |
| Build for production | `hugo --gc --minify` |
| Generate index | `./scripts/generate_index.rb` |
| Create new post | `./scripts/dev.sh new-post "Title"` |
| View logs | `./scripts/dev.sh logs` |
| Stop server | `./scripts/dev.sh stop` |

## Project Structure

```
akitaonrails-hugo/
├── content/                    # All blog posts and pages (Markdown)
│   ├── _index.md               # Auto-generated homepage index
│   ├── about.md                # About page
│   └── YYYY/MM/DD/slug/        # Blog posts organized by date
│       └── index.md
├── layouts/                    # Hugo template overrides
│   ├── shortcodes/             # Custom shortcodes (youtube.html)
│   ├── partials/               # Custom partials
│   │   ├── components/         # Component overrides (comments.html - Disqus)
│   │   └── custom/             # Hextra customization hooks
│   └── _default/               # Default template overrides (RSS)
├── scripts/                    # Utility scripts
│   ├── dev.sh                  # Docker development helper
│   └── generate_index.rb       # Generates _index.md from all posts
├── _vendor/                    # Vendored Hextra theme (go mod vendor)
├── hugo.yaml                   # Main Hugo configuration
├── go.mod / go.sum             # Hugo module dependencies
├── docker-compose.yml          # Docker development environment
└── Dockerfile                  # Docker image definition
```

## Development Environment

### Docker (Recommended)

```bash
# Start development server
./scripts/dev.sh start

# Server runs at http://localhost:1313
# Hot-reload enabled - changes to content/layouts/hugo.yaml auto-refresh
```

### Local Installation

Requirements:
- **Hugo Extended** v0.145.0+ (must be Extended version for SCSS support)
- **Go** 1.21+
- **Ruby** (for index generation scripts)

```bash
# Run generate_index first, then start server
./scripts/generate_index.rb
hugo server --logLevel debug --disableFastRender -p 1313
```

## Content Conventions

### Post Location

Posts follow the pattern: `content/YYYY/MM/DD/slug-name/index.md`

Example: `content/2024/12/14/my-post-title/index.md`

### Frontmatter Format

```yaml
---
title: "Post Title"
date: '2024-12-14T16:48:00-03:00'
slug: my-post-title
tags:
- tag1
- tag2
draft: false
---
```

Required fields:
- `title`: Post title (used in listings and SEO)
- `date`: ISO 8601 format with timezone (typically -03:00 for Brazil)
- `draft`: Set to `false` for published posts

Optional fields:
- `slug`: URL slug (defaults to directory name if omitted)
- `tags`: Array of tags
- `description`: Meta description for SEO

### Creating New Posts

```bash
# Using Docker helper (creates proper directory structure)
./scripts/dev.sh new-post "My New Post Title"

# Manually
mkdir -p content/2025/01/15/my-new-post
# Create content/2025/01/15/my-new-post/index.md with frontmatter
```

### Images in Posts

Images can be referenced from:
- Same directory as `index.md` (relative paths)
- External URLs (legacy posts use S3: `s3.amazonaws.com/akitaonrails/assets/`)

## Index Generation

The homepage (`content/_index.md`) is **auto-generated** by `scripts/generate_index.rb`. This script:
- Scans all `index.md` files in `content/`
- Extracts title and date from frontmatter
- Groups posts by year and month
- Generates a chronological listing

**IMPORTANT**: Run `./scripts/generate_index.rb` after adding new posts (Docker mode runs this automatically on startup).

## Custom Shortcodes

### YouTube Embed

```markdown
{{< youtube id="VIDEO_ID" >}}
```

This uses a custom shortcode at `layouts/shortcodes/youtube.html` that creates responsive 16:9 embeds.

## Theme Customization

This site uses the Hextra theme with customizations:

- **`layouts/partials/custom/head-end.html`**: Custom CSS for embeds and typography
- **`layouts/partials/components/comments.html`**: Disqus integration
- **`layouts/_default/list.rss.xml`**: Custom RSS feed (includes full content, limited to 20 items)

Hextra provides hooks in `layouts/_partials/custom/` for safe customization.

## Configuration Details

### `hugo.yaml` Key Settings

- Language: `pt-BR` (Brazilian Portuguese)
- Theme: `light` by default
- Comments: Disqus (`akitaonrails` shortname)
- Author: Fabio Akita

### Markdown Processing

- Raw HTML enabled (`goldmark.renderer.unsafe: true`)
- Syntax highlighting uses CSS classes (not inline styles)

## Deployment

### GitHub Pages (Primary)

Configured in `.github/workflows/pages.yaml`:
- Triggers on push to `master` branch
- Uses Hugo v0.145.0
- Builds with `hugo --gc --minify`
- Deploys to GitHub Pages automatically

### Netlify (Alternative)

Configured in `netlify.toml`:
- Uses Hugo v0.152.2
- Builds with `hugo --gc --minify`

## Utility Scripts

| Script | Purpose |
|--------|---------|
| `scripts/dev.sh` | Docker development helper (start/stop/logs/new-post) |
| `scripts/generate_index.rb` | Regenerates `_index.md` homepage listing |
| `scripts/fix-old-code-blocks.rb` | Migration script: converts `---lang` to ````lang` |
| `scripts/fix_images.rb` | Migration script for image URLs |
| `scripts/fix_html_entities.rb` | Migration script for HTML entities |
| `scripts/fix-s3-params.rb` | Migration script for S3 URLs |

Migration scripts are for one-time content fixes - typically not needed for new work.

## Version Requirements

| Tool | Version |
|------|---------|
| Hugo | 0.145.0+ (Extended) |
| Go | 1.21+ |
| Ruby | Any modern version (for scripts) |

## Gotchas and Notes

1. **Hugo Extended Required**: The theme uses SCSS - regular Hugo won't work.

2. **Index regeneration**: The `_index.md` file is auto-generated. Don't edit it manually - your changes will be overwritten.

3. **Date format**: Use ISO 8601 with timezone in frontmatter: `'2024-12-14T16:48:00-03:00'`

4. **Legacy content**: Many old posts use external S3 URLs for images. These work but are legacy patterns.

5. **Disqus comments**: Comments are enabled site-wide via the Disqus shortname in `hugo.yaml`.

6. **Line length**: Markdownlint is configured to ignore line length (`MD013: false` in `.markdownlint.json`).

7. **Default branch**: The repository uses `master` (not `main`) as the default branch.

8. **Content directory structure**: Hugo expects posts in `content/YYYY/MM/DD/slug/index.md` format. The directory path contributes to the URL structure.

## Contributing

1. Fork and clone the repository
2. Start the dev environment with `./scripts/dev.sh start`
3. Create a feature branch
4. Make changes and test locally
5. Run `./scripts/dev.sh generate-index` if adding posts
6. Submit a pull request

Keep changes small and focused. For major changes, open an issue first.
