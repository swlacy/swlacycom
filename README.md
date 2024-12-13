# swlacy.com

Depends:
- [Hugo](https://formulae.brew.sh/formula/hugo)
- [TailwindCSS](https://formulae.brew.sh/formula/tailwindcss)

Clone:
```bash
git clone --recurse-submodules https://github.com/swlacy/swlacy.com.git
```

Dev:
```bash
cd swlacy.com

# These mounts default to the content in the swlacycom-content submodule
# Set to override that content
export HUGO_CONTENT_SOURCE='<path to mount to /content>'
export HUGO_STATIC_SOURCE='<path to mount to /static>'

chmod +x scripts/build.sh
scripts/build.sh serve
```