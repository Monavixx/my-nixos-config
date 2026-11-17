local flake = string.format(
    '(builtins.getFlake "%s")',
    vim.g.flake_root
)
local hostname = vim.g.nix_hostname;

vim.lsp.config("nixd", {
    settings = {
        nixd = {
            nixpkgs = {
                expr = "import " .. flake .. ".inputs.nixpkgs { }",
            },
            options = {
                nixos = {
                    expr = flake .. ".nixosConfigurations." .. hostname .. ".options",
                },
                home_manager = {
                    expr = flake .. ".nixosConfigurations." ..
                        hostname .. ".options.home-manager.users.type.getSubOptions []",
                },
            },
        },
    },
})
vim.lsp.enable("nixd")
