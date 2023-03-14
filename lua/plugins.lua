local M = {}

function M.setup()
  -- Indicate first time installation
  local packer_bootstrap = false

  -- packer.nvim configuration
  local conf = {
    display = {
      open_fn = function()
        return require("packer.util").float { border = "rounded" }
      end,
    },
  }

  -- Check if packer.nvim is installed
  -- Run PackerCompile if there are changes in this file
  local function packer_init()
    local fn = vim.fn
    local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
      packer_bootstrap = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
      }
      vim.cmd [[packadd packer.nvim]]
    end
    vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
  end

	function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
  end

  -- Plugins
  local function plugins(use)
    use { "wbthomason/packer.nvim" }
		use { "preservim/nerdtree" }
		use { "navarasu/onedark.nvim" }
    use { "majutsushi/tagbar" }
		use { "ryanoasis/vim-devicons" }
		use { "nathanaelkane/vim-indent-guides" }
		use { "Xuyuanp/nerdtree-git-plugin" }
		use { "airblade/vim-gitgutter" }
		use { "blueyed/vim-diminactive" }
		use { "vim-airline/vim-airline" }
		use { "vim-airline/vim-airline-themes" }
		use { "tpope/vim-surround" }
		use { "ctrlpvim/ctrlp.vim" }               -- "Ctrl + P for search file
		use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
		use { "williamboman/mason.nvim" }
		use { "neovim/nvim-lspconfig" } -- Configurations for Nvim LSP
		use { "hrsh7th/nvim-cmp" } -- Autocompletion plugin
		use { "hrsh7th/cmp-nvim-lsp" } -- LSP source for nvim-cmp
		use { "saadparwaiz1/cmp_luasnip" } -- Snippets source for nvim-cmp
		use { "L3MON4D3/LuaSnip" } -- Snippets plugin 

    -- Colorscheme
    use {
      "sainnhe/everforest",
      config = function()
        vim.cmd "colorscheme everforest"
      end,
    }

    -- Startup screen
    use {
      "goolord/alpha-nvim",
      config = function()
        require("config.alpha").setup()
      end,
    }

    -- Git
    use {
      "TimUntersberger/neogit",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("config.neogit").setup()
      end,
    }

    if packer_bootstrap then
      print "Restart Neovim required after installation!"
      require("packer").sync()
    end
  end

  packer_init()

  local packer = require "packer"
  packer.init(conf)
  packer.startup(plugins)

	-- map
	map("n", "<leader>", ":NERDTreeFocus<CR>")
	map("n", "<C-n>", ":NERDTreeToggle<CR>")
	map("n", "<C-t>", ":TagbarToggle<CR>")
	-- map("n", "<Leader>a", ":cclose<CR>")
	
	-- function! GitStatus()
		-- let [a,m,r] = GitGutterGetHunkSummary()
		-- return printf('+%d ~%d -%d', a, m, r)
	-- end
	-- set statusline+=%{GitStatus()}

	vim.g.gitgutter_highlight_lines = 1

	------------------------------------
	-- tagbar 설정
	------------------------------------
	-- tagbar 생성 시 우측 하단에 위치하게끔 생성
	vim.g.tagbar_position = 'right'
	------------------------------------
	-- vim-airline 설정
	------------------------------------
	-- powerline-font 활성화
	vim.g.airline_powerline_fonts = 1
	-- luna 테마 사용
	vim.g.airline_theme = 'luna'
	-- tabline 에 파일명만 출력 되도록 설정
	vim.g['airline#extensions#tabline#formatter'] = 'unique_tail'
	-- 창의 상단에 표시되도록 설정
  -- vim.g.airline_statusline_ontop = 1
	-- 탭라인 허용
	vim.g['airline#extensions#tabline#enabled'] = 1
	-- 항상 tabline 을 표시
	vim.g['airline#extensions#tabline#show_tabs'] = 1
	------------------------------------
	-- NERDTree 설정
	------------------------------------
	-- 창 크기(가로)를 20 으로 설정
	vim.g.NERDTreeWinSize = 30

	local tree = require "nvim-treesitter.configs" 
	tree.setup {
		-- ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
		ignore_install = { "" }, -- List of parsers to ignore installing
		highlight = {
			enable = true,              -- false will disable the whole extension
			disable = { "" },  -- list of language that will be disabled
			-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
			-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
			-- Using this option may slow down your editor, and you may see some duplicate highlights.
			-- Instead of true it can also be a list of languages
			additional_vim_regex_highlighting = false,
		},
	}

	-- Use an on_attach function to only map the following keys
	-- after the language server attaches to the current buffer
	local custom_on_attach = function(client, bufnr)
		-- Enable completion triggered by <c-x><c-o>
		vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

		-- Mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local bufopts = { noremap=true, silent=true, buffer=bufnr }
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
		vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
		vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
		vim.keymap.set('n', '<space>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, bufopts)
		vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
		vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
		vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
		vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
	end

	local lsp_flags = {
		-- This is the default in Nvim 0.7+
		debounce_text_changes = 150,
	}

	-- Add additional capabilities supported by nvim-cmp
	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	local lspconfig = require('lspconfig')

	-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
	-- language server
	lspconfig.kotlin_language_server.setup{
			on_attach = custom_on_attach,
			flags = lsp_flags,
			capabilities = capabilities,
			-- cmd = { "/Users/user_1/Work/kotlin-language-server/gradlew", ":server:run" }
			cmd = { "/Users/user_1/.config/nvim-beginner/share/nvim/mason/packages/kotlin-language-server/server/bin/kotlin-language-server" }
	}

	lspconfig.jedi_language_server.setup({
		cmd = { '/Users/user_1/.config/nvim-beginner/share/nvim/mason/packages/jedi-language-server/venv/bin/jedi-language-server' },
		on_attach = custom_on_attach,
		flags = lsp_flags,
		capabilities = capabilities,
		on_new_config = function(new_config, root_dir)
			new_config.init_options = {
				workspace = {
					environmentPath = '/Users/user_1/Work/nfas/ntm-airflow/.venv/bin/python',
				},
			}
		end,
	})
	-- lspconfig.jedi_language_server.setup{
			--on_attach = custom_on_attach,
			--flags = lsp_flags,
			--capabilities = capabilities,
			--init_options = {
					--workspace = {
						  --extraPaths = { "/Users/user_1/Work/nfas/ntm-airflow/.venv/lib/python3.9/site-packages" }
					--}
			--}
	--}

	-- luasnip setup
	local luasnip = require 'luasnip'

	-- nvim-cmp setup
	local cmp = require 'cmp'
	cmp.setup {
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		mapping = cmp.mapping.preset.insert({
			['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
			['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
			-- C-b (back) C-f (forward) for snippet placeholder navigation.
			['<C-Space>'] = cmp.mapping.complete(),
			['<CR>'] = cmp.mapping.confirm {
				behavior = cmp.ConfirmBehavior.Replace,
				select = true,
			},
			['<Tab>'] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end, { 'i', 's' }),
			['<S-Tab>'] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { 'i', 's' }),
		}),
		sources = {
			{ name = 'nvim_lsp' },
			{ name = 'luasnip' },
		},
	}

	-- mason
	require("mason").setup()
end

return M
