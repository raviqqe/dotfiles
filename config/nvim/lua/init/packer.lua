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
    use 'b3nj5m1n/kommentary'
    use 'christoomey/vim-tmux-navigator'
    use 'cocopon/iceberg.vim'
    use 'farmergreg/vim-lastplace'
    use 'hoob3rt/lualine.nvim'
    use 'lukas-reineke/indent-blankline.nvim'
    use 'maxbrunsfeld/vim-yankstack'
    use {'nvim-telescope/telescope.nvim', requires = {"nvim-lua/plenary.nvim"}}
    use 'pbrisbin/vim-mkdir'
    use 'phaazon/hop.nvim'
    use 'rhysd/clever-f.vim'
    use 'tpope/vim-abolish'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-sleuth'
    use 'tpope/vim-surround'
    use 'windwp/nvim-autopairs'
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
    use 'L3MON4D3/LuaSnip'
    use 'neovim/nvim-lspconfig'
    use 'pen-lang/pen.vim'
    use 'ray-x/cmp-treesitter'
    use 'sheerun/vim-polyglot'
    use 'styled-components/vim-styled-components'
end)
