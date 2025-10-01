# Portfolio Website

A modern, clean portfolio website built with Hugo and the Terminal theme. Inspired by clean, developer-focused designs with a retro terminal aesthetic.

## 🚀 Live Demo

Visit the live site: [https://mohsenabdolahi.github.io/](https://mohsenabdolahi.github.io/)

## 📋 Features

- **Fast & Lightweight**: Built with Hugo static site generator
- **Responsive Design**: Works perfectly on all devices
- **Clean Terminal Aesthetic**: Retro, developer-friendly design
- **Syntax Highlighting**: Beautiful code blocks with Chroma
- **SEO Optimized**: Meta tags, Open Graph, and structured data
- **Blog Functionality**: Write posts in Markdown
- **Project Showcase**: Dedicated section for projects
- **Contact Page**: Multiple ways to get in touch
- **Dark Theme**: Easy on the eyes for developers

## 🛠️ Built With

- **[Hugo](https://gohugo.io/)** - Fast static site generator
- **[Terminal Theme](https://github.com/panr/hugo-theme-terminal)** - Clean, retro Hugo theme
- **Markdown** - Content creation
- **HTML/CSS/JavaScript** - Frontend technologies
- **Git** - Version control

## 📁 Project Structure

```
portfolio/
├── content/              # Markdown content files
│   ├── posts/           # Blog posts
│   ├── about.md         # About page
│   ├── projects.md      # Projects showcase
│   ├── contact.md       # Contact information
│   └── _index.md        # Homepage content
├── themes/
│   └── terminal/        # Terminal theme (git submodule)
├── static/              # Static assets (images, files)
├── data/                # Data files
├── layouts/             # Custom layout overrides (if any)
├── assets/              # Assets to be processed
├── hugo.toml            # Hugo configuration
└── README.md           # This file
```

## 🚀 Quick Start

### Prerequisites

- **Hugo Extended** (v0.90.x or later)
- **Git**
- **Node.js** (optional, for theme development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/mohsenabdolahi/portfolio.git
   cd portfolio
   ```

2. **Initialize and update git submodules**
   ```bash
   git submodule init
   git submodule update
   ```

3. **Start the development server**
   ```bash
   hugo server --buildDrafts
   ```

4. **Open your browser**
   Navigate to `http://localhost:1313`

### Alternative: Using Hugo Modules

If you prefer Hugo modules over git submodules:

1. **Initialize Hugo modules**
   ```bash
   hugo mod init github.com/yourusername/portfolio
   ```

2. **Update hugo.toml** to use the theme as a module:
   ```toml
   [module]
   [[module.imports]]
     path = 'github.com/panr/hugo-theme-terminal/v4'
   ```

3. **Get the theme**
   ```bash
   hugo mod get
   ```

## ✏️ Content Management

### Adding Blog Posts

1. Create a new post:
   ```bash
   hugo new posts/my-new-post.md
   ```

2. Edit the front matter and content:
   ```markdown
   ---
   title: "My New Post"
   date: 2025-01-27T10:00:00+00:00
   draft: false
   toc: true
   tags:
     - technology
     - programming
   ---

   Your content here...
   ```

### Updating Projects

Edit `content/projects.md` to add or modify project information.

### Customizing Pages

- **About**: Edit `content/about.md`
- **Contact**: Edit `content/contact.md`
- **Homepage**: Edit `content/_index.md`

## 🎨 Customization

### Site Configuration

Edit `hugo.toml` to customize:

- Site title and description
- Author information
- Menu items
- Social links
- Theme settings

### Adding Custom CSS

1. Create `assets/css/custom.css`
2. Add your custom styles
3. Reference it in your layout or config

### Adding Custom JavaScript

1. Create `assets/js/custom.js`
2. Add your custom scripts
3. Reference it in your layout

## 🚀 Deployment

### GitHub Pages

1. **Create `.github/workflows/hugo.yml`**:
   ```yaml
   name: Deploy Hugo site to Pages

   on:
     push:
       branches: ["main"]
     workflow_dispatch:

   permissions:
     contents: read
     pages: write
     id-token: write

   concurrency:
     group: "pages"
     cancel-in-progress: false

   defaults:
     run:
       shell: bash

   jobs:
     build:
       runs-on: ubuntu-latest
       env:
         HUGO_VERSION: 0.123.7
       steps:
         - name: Install Hugo CLI
           run: |
             wget -O ${{ runner.temp }}/hugo.deb https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb
             sudo dpkg -i ${{ runner.temp }}/hugo.deb
         - name: Checkout
           uses: actions/checkout@v4
           with:
             submodules: recursive
         - name: Setup Pages
           id: pages
           uses: actions/configure-pages@v4
         - name: Build with Hugo
           env:
             HUGO_ENVIRONMENT: production
             HUGO_ENV: production
           run: |
             hugo \
               --gc \
               --minify \
               --baseURL "${{ steps.pages.outputs.base_url }}/"
         - name: Upload artifact
           uses: actions/upload-pages-artifact@v2
           with:
             path: ./public

     deploy:
       environment:
         name: github-pages
         url: ${{ steps.deploy.outputs.page_url }}
       runs-on: ubuntu-latest
       needs: build
       steps:
         - name: Deploy to GitHub Pages
           id: deploy
           uses: actions/deploy-pages@v3
   ```

2. **Enable GitHub Pages** in your repository settings
3. **Push to main branch** to trigger deployment

### Netlify

1. Connect your GitHub repository to Netlify
2. Set build command: `hugo --gc --minify`
3. Set publish directory: `public`
4. Set environment variable: `HUGO_VERSION = 0.123.7`

### Vercel

1. Connect your GitHub repository to Vercel
2. Vercel will auto-detect Hugo and configure build settings

## 📝 Writing Tips

### Front Matter Options

```markdown
---
title: "Post Title"
date: 2025-01-27T10:00:00+00:00
draft: false           # Set to true for drafts
toc: true             # Table of contents
images: ["/img/post.jpg"] # Social media images
tags:
  - programming
  - web-development
categories:
  - tutorials
---
```

### Code Highlighting

Use fenced code blocks with language specification:

````markdown
```javascript
function hello() {
  console.log("Hello, World!");
}
```
````

### Images

Add images to `static/img/` and reference them:

```markdown
![Alt text](/img/my-image.jpg)
```

## 🔧 Development

### Theme Development

If you want to customize the theme:

1. **Fork the terminal theme** repository
2. **Update the submodule** to point to your fork
3. **Make changes** in `themes/terminal/`
4. **Test your changes** locally

### Adding Shortcodes

Create custom shortcodes in `layouts/shortcodes/`:

```html
<!-- layouts/shortcodes/highlight.html -->
<div class="highlight-box">
  {{ .Inner | markdownify }}
</div>
```

Usage in content:
```markdown
{{< highlight >}}
This is highlighted content
{{< /highlight >}}
```

## 🐛 Troubleshooting

### Common Issues

1. **Theme not found**: Make sure git submodules are initialized and updated
2. **Build errors**: Check Hugo version (needs Extended version)
3. **Styles not loading**: Verify theme configuration in hugo.toml
4. **Content not showing**: Check front matter and draft status

### Debug Commands

```bash
# Check Hugo version
hugo version

# Verbose build output
hugo --verbose

# Check config
hugo config

# Clean cache
hugo mod clean
```

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

The Terminal theme is also licensed under MIT. See the [theme license](themes/terminal/LICENSE.md) for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📞 Contact

- **Website**: [mohsenabdolahi.github.io](https://mohsenabdolahi.github.io)
- **Email**: [Contact page](/contact)
- **GitHub**: [@mohsenabdolahi](https://github.com/mohsenabdolahi)
- **LinkedIn**: [mohsen-abdolahi](https://linkedin.com/in/mohsen-abdolahi)

---

⭐ **If you find this project helpful, please consider giving it a star on GitHub!**