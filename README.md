# LSP Zero

Collection of functions that will help you setup Neovim's LSP client, so you can get IDE-like features with minimum effort.

Out of the box it will help you integrate [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) (an autocompletion plugin) and [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) (a collection of configurations for various language servers). So a minimal config can look like this.

```lua
require('lsp-zero')
require('lspconfig').intelephense.setup({})
```

With this code when `intelephense` (a language server for PHP) is active you'll get all the features Neovim offers by default plus autocompletion. [See demo in asciinema](https://asciinema.org/a/648850).

## How to get started

If you are new to Neovim and you don't have a configuration file (`init.lua`) follow this [step by step tutorial](https://lsp-zero.netlify.app/v3.x/tutorial.html).

If you know how to configure Neovim go to the [Getting started](https://lsp-zero.netlify.app/v3.x/getting-started.html) page in the documentation.

Also consider `nvim-lspconfig` works fine without lsp-zero. And you can setup `nvim-cmp` by yourself. I wrote a blog post that shows how to do it: [You might not need lsp-zero](https://lsp-zero.netlify.app/v3.x/blog/you-might-not-need-lsp-zero.html).

## Documentation

You can browse the documentation at [lsp-zero.netlify.app/v3.x](https://lsp-zero.netlify.app/v3.x/introduction.html)

* [Installation and basic usage](https://lsp-zero.netlify.app/v3.x/getting-started.html)
* [LSP configuration](https://lsp-zero.netlify.app/v3.x/language-server-configuration.html)
* [Autocompletion](https://lsp-zero.netlify.app/v3.x/autocomplete.html)
* [Frequent Questions](https://lsp-zero.netlify.app/v3.x/faq.html) 

<details>

<summary>Expand: More Documentation Links </summary>

* Integrations

  * [Integrate with mason.nvim](https://lsp-zero.netlify.app/v3.x/guide/integrate-with-mason-nvim.html)
  * [Enable folds with nvim-ufo](https://lsp-zero.netlify.app/v3.x/guide/quick-recipes.html#enable-folds-with-nvim-ufo)
  * [Setup copilot.lua + nvim-cmp](https://lsp-zero.netlify.app/v3.x/guide/setup-copilot-lua-plus-nvim-cmp.html)
  * [Setup with nvim-jdtls](https://lsp-zero.netlify.app/v3.x/guide/setup-with-nvim-jdtls.html)
  * [Setup lsp-inlayhints.nvim](https://lsp-zero.netlify.app/v3.x/guide/quick-recipes.html#enable-inlay-hints-with-lsp-inlayhints-nvim)
  * [Setup with nvim-navic](https://lsp-zero.netlify.app/v3.x/guide/quick-recipes.html#setup-with-nvim-navic)
  * [Setup with rustaceanvim](https://lsp-zero.netlify.app/v3.x/guide/quick-recipes.html#setup-with-rustaceanvim)
  * [Setup with flutter-tools](https://lsp-zero.netlify.app/v3.x/guide/quick-recipes.html#setup-with-flutter-tools)
  * [Setup with nvim-metals](https://lsp-zero.netlify.app/v3.x/guide/quick-recipes.html#setup-with-nvim-metals)
  * [Setup with haskell-tools](https://lsp-zero.netlify.app/v3.x/guide/quick-recipes.html#setup-with-haskell-tools)

* Guides

  * [What to do when the language server doesn't start?](https://lsp-zero.netlify.app/v3.x/guide/what-to-do-when-lsp-doesnt-start.html)
  * [Lazy loading with lazy.nvim](https://lsp-zero.netlify.app/v3.x/guide/lazy-loading-with-lazy-nvim.html)
  * [lua_ls for Neovim](https://lsp-zero.netlify.app/v3.x/guide/neovim-lua-ls.html)
  * [Configure Volar 2.0 (with typescript support)](https://lsp-zero.netlify.app/v3.x/guide/configure-volar-v2.html)
  * [Migrate from v2.x to v3.x](https://lsp-zero.netlify.app/v3.x/guide/migrate-from-v2-branch.html)
  * [Migrate from v1.x to v3.x](https://lsp-zero.netlify.app/v3.x/guide/migrate-from-v1-branch.html)

* API

  * [Commands](https://lsp-zero.netlify.app/v3.x/reference/commands.html)
  * [Variables](https://lsp-zero.netlify.app/v3.x/reference/variables.html)
  * [Lua API](https://lsp-zero.netlify.app/v3.x/guide/what-to-do-when-lsp-doesnt-start.html) 

* Blog posts

  * [You might not need lsp-zero](https://lsp-zero.netlify.app/v3.x/blog/you-might-not-need-lsp-zero.html)
  * [lsp-zero under the hood](https://lsp-zero.netlify.app/v3.x/blog/under-the-hood.html)
  * [require lsp-zero](https://lsp-zero.netlify.app/v3.x/blog/what-require-lsp-zero-does.html)
  * [ThePrimeagen 0 to LSP config](https://lsp-zero.netlify.app/v3.x/blog/theprimeagens-config-from-2022.html)

</details>

## If you need any help

Feel free to open a new [discussion](https://github.com/VonHeikemen/lsp-zero.nvim/discussions) in this repository. Or join the chat [#lsp-zero-nvim:matrix.org](https://matrix.to/#/#lsp-zero-nvim:matrix.org).

If you have problems with a language server read this guide: [What to do when the language server doesn't start?](https://lsp-zero.netlify.app/v3.x/guide/what-to-do-when-lsp-doesnt-start.html)

If you want to migrate from a previous version to the `v3.x` branch, follow one of these guides:

* [Migrate from v2.x to v3.x](https://lsp-zero.netlify.app/v3.x/guide/migrate-from-v2-branch.html)
* [Migrate from v1.x to v3.x](https://lsp-zero.netlify.app/v3.x/guide/migrate-from-v1-branch.html)

### When asking for help for a specific language

One thing you should know when asking for help online: asking the question "how to configure [random language] with lsp-zero?" is not going to give you the results you want. You probably want to ask "how to configure the language server for [random language] using [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)?" That will give you better results because `nvim-lspconfig` is the plugin that configures the language servers.

## Quickstart (for the impatient)

If you are not that impatient, I recommend reading the [Getting started](https://lsp-zero.netlify.app/v3.x/getting-started.html) page.

But for those of you that just want to copy/paste, here are some templates you can use.

* [Lua template configuration](https://lsp-zero.netlify.app/v3.x/template/lua-config.html)
* [Vimscript template configuration](https://lsp-zero.netlify.app/v3.x/template/vimscript-config.html)
* [ThePrimeagen's "0 to LSP" config updated](https://lsp-zero.netlify.app/v3.x/blog/theprimeagens-config-from-2022.html)

## Support

If you find this tool useful and want to support my efforts, [buy me a coffee ☕](https://www.buymeacoffee.com/vonheikemen).

[![buy me a coffee](https://res.cloudinary.com/vonheikemen/image/upload/v1618466522/buy-me-coffee_ah0uzh.png)](https://www.buymeacoffee.com/vonheikemen)

