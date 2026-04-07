---
title: How to Contribute to the AkitaOnRails Blog Using Docker
date: "2025-08-29T22:37:16-03:00"
slug: how-to-contribute-to-the-akitaonrails-blog-using-docker
tags:
  - docker
  - hugo
  - desenvolvimento
  - contribuição
  - open-source
draft: false
translationKey: contributing-to-blog-with-docker
description: A quick walkthrough on using Docker to spin up the AkitaOnRails blog development environment and start contributing without installing Hugo, Go, or Ruby locally.
---

Contributing to open source projects can be a pain when you have to set up a complex development environment. On the AkitaOnRails blog, that used to mean installing Hugo Extended, Go, Ruby, and all their dependencies. Now we have a much simpler solution: **Docker**.

## The Problem

Before, to contribute to the blog you had to:

1. Install Hugo Extended
2. Install Go
3. Install Ruby
4. Set up all the dependencies
5. Generate the post index manually

This created barriers for new contributors and could cause conflicts with other installations on the system. A nightmare.

## The Solution: Docker

Now all you need is Docker and Docker Compose. Everything else runs inside isolated containers.

### Quick Setup

```bash
# Clone the repository
git clone https://github.com/akitaonrails/akitaonrails.github.io.git
cd akitaonrails.github.io

# Start the environment
./scripts/dev.sh start

# Open the blog
open http://localhost:1313
```

Done! The blog is running and you can start contributing.

## Useful Commands

The project includes scripts that make development easier:

```bash
# See all available commands
./scripts/dev.sh help

# Create a new post
./scripts/dev.sh new-post "Título do Meu Post"

# View server logs
./scripts/dev.sh logs

# Generate the post index
./scripts/dev.sh generate-index

# Stop the environment
./scripts/dev.sh stop
```

## Creating a Post

Creating a new post is dead simple:

```bash
./scripts/dev.sh new-post "Como Contribuir no Blog do AkitaOnRails"
```

The script automatically:

- Creates the directory structure with the current date
- Generates an `index.md` file with basic front matter
- The Hugo server reloads automatically

## Structure of a Post

The created file will have this structure:

```markdown
---
title: "Título do Post"
date: "2025-08-29"
draft: false
description: "Descrição do post"
tags: [tag1, tag2]
categories: [categoria]
---

Conteúdo do post aqui...
```

## Advantages of Docker

### For Contributors

- **Fast setup**: Docker is the only requirement
- **Isolated environment**: Stays out of the way of your local system
- **Hot reload**: Changes show up automatically
- **Reproducible**: Works the same way for everyone

### For the Project

- **Fewer issues**: Consistent environment
- **More contributors**: Lower barrier to entry
- **Maintenance**: Easy to update dependencies

## How It Works

The Docker environment includes:

- **Hugo Extended**: Static site generator
- **Go**: For Hugo modules
- **Ruby**: For the index generation script
- **Volumes**: For hot reload of files

The `docker-compose.yml` maps the local directories into the container, so when you edit a file, Hugo detects the change and reloads automatically.

## Local Development (Alternative)

If you prefer to skip Docker, you can still install everything locally:

```bash
# Generate the index
cd content && ruby generate_index.rb

# Run the server
hugo server --logLevel debug --disableFastRender -p 1313
```

But Docker is way more practical!

## Next Steps

1. **Test the environment**: Run `./scripts/dev.sh start`
2. **Create a post**: Use `./scripts/dev.sh new-post`
3. **Explore the code**: See how to customize layouts
4. **Contribute**: Open a Pull Request

---

**Tip**: The Docker environment automatically saves your changes and reloads the server. Just edit the files and watch the changes in real time! 🚀
