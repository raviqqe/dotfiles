local install_path = vim.fn.stdpath 'data' ..
                         '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({
        'git', 'clone', 'https://github.com/wbthomason/packer.nvim',
        install_path
    })
end

require'packer'.startup(function()
    use 'wbthomason/packer.nvim'

    use '907th/vim-auto-save'
    use 'airblade/vim-gitgutter'
    use 'christoomey/vim-tmux-navigator'
    use 'cocopon/iceberg.vim'
    use 'easymotion/vim-easymotion'
    use 'farmergreg/vim-lastplace'
    use 'hoob3rt/lualine.nvim'
    use 'jiangmiao/auto-pairs'
    use 'lukas-reineke/indent-blankline.nvim'
    use 'pbrisbin/vim-mkdir'
    use 'rhysd/clever-f.vim'
    use 'svermeulen/vim-yoink'
    use 'terryma/vim-multiple-cursors'
    use 'thinca/vim-quickrun'
    use 'tpope/vim-abolish'
    use 'tpope/vim-commentary'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-sleuth'
    use 'tpope/vim-surround'
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

    -- fuzzy finder

    use {'junegunn/fzf', run = './install --bin'}
    use 'junegunn/fzf.vim'

    -- languages

    use 'ap/vim-css-color'
    use 'ein-lang/ein.vim'
    use 'fatih/vim-go'
    use 'hashivim/vim-hashicorp-tools'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/nvim-cmp'
    use 'L3MON4D3/LuaSnip'
    use 'neovim/nvim-lspconfig'
    use 'pen-lang/pen.vim'
    use 'ray-x/cmp-treesitter'
    use 'sbdchd/neoformat'
    use 'sheerun/vim-polyglot'
    use {'styled-components/vim-styled-components', branch = 'main'}
    use {'tzachar/cmp-tabnine', run = './install.sh'}
    use 'w0rp/ale'
end)
