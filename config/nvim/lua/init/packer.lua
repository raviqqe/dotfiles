local install_path = vim.fn.stdpath('data') ..
                         '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({
        'git', 'clone', 'https://github.com/wbthomason/packer.nvim',
        install_path
    })
end

require('packer').startup(function()
    use 'wbthomason/packer.nvim'

    use '907th/vim-auto-save'
    use 'airblade/vim-gitgutter'
    use 'cappyzawa/trim.nvim'
    use 'christoomey/vim-tmux-navigator'
    use 'cocopon/iceberg.vim'
    use 'easymotion/vim-easymotion'
    use 'farmergreg/vim-lastplace'
    use 'hoob3rt/lualine.nvim'
    use 'jiangmiao/auto-pairs'
    use 'lukas-reineke/indent-blankline.nvim'
    use 'nvim-telescope/telescope.nvim'
    use 'pbrisbin/vim-mkdir'
    use 'rhysd/clever-f.vim'
    use 'svermeulen/vim-yoink'
    use 'tpope/vim-abolish'
    use 'tpope/vim-commentary'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-sleuth'
    use 'tpope/vim-surround'
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

    -- languages

    use 'ap/vim-css-color'
    use 'fatih/vim-go'
    use 'hashivim/vim-hashicorp-tools'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-emoji'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/nvim-cmp'
    use({
        "jose-elias-alvarez/null-ls.nvim",
        requires = {"nvim-lua/plenary.nvim", "neovim/nvim-lspconfig"}
    })
    use 'L3MON4D3/LuaSnip'
    use 'neovim/nvim-lspconfig'
    use 'pen-lang/pen.vim'
    use 'ray-x/cmp-treesitter'
    use 'sheerun/vim-polyglot'
    use 'styled-components/vim-styled-components'
    use {'tzachar/cmp-tabnine', run = './install.sh'}
end)
