{ config, pkgs, nixvim, lib, ... }:


{
    imports = [
        nixvim.homeModules.nixvim
    ];
# Home Manager needs a bit of information about you and the paths it should
# manage.
    home.username = "adriendumazaud";
    home.homeDirectory = "/Users/adriendumazaud";

# This value determines the Home Manager release that your configuration is
# compatible with. This helps avoid breakage when a new Home Manager release
# introduces backwards incompatible changes.
#
# You should not change this value, even if you update Home Manager. If you do
# want to update the value, then make sure to first check the Home Manager
# release notes.
    home.stateVersion = "25.05"; # Please read the comment before changing.

# The home.packages option allows you to install Nix packages into your
# environment.
        home.packages = with pkgs;
    [
        hello
            nerd-fonts.fira-code
            wezterm
            eza
            bat
            zoxide
    ];
    fonts.fontconfig.enable = true;

# Home Manager is pretty good at managing dotfiles. The primary way to manage
# plain files is through 'home.file'.
    home.file = {
# # Building this configuration will create a copy of 'dotfiles/screenrc' in
# # the Nix store. Activating the configuration will then make '~/.screenrc' a
# # symlink to the Nix store copy.
# ".screenrc".source = dotfiles/screenrc;

# # You can also set the file content immediately.
# ".gradle/gradle.properties".text = ''
#   org.gradle.console=verbose
#   org.gradle.daemon.idletimeout=3600000
# '';
    };

# Home Manager can also manage your environment variables through
# 'home.sessionVariables'. These will be explicitly sourced when using a
# shell provided by Home Manager. If you don't want to manage your shell
# through Home Manager then you have to manually source 'hm-session-vars.sh'
# located at either
#
#  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
#
# or
#
#  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
#
# or
#
#  /etc/profiles/per-user/adriendumazaud/etc/profile.d/hm-session-vars.sh
#
    home.sessionVariables = {
# EDITOR = "emacs";
    };
    programs = {
        wezterm = {
            enable = true;
            enableZshIntegration = true;
            extraConfig = 
                ''
                local wezterm = require 'wezterm'
                local config = wezterm.config_builder()

                config.color_scheme = "Gruvbox Dark (Gogh)"
                config.font = wezterm.font("FiraCode Nerd Font Mono")
                config.font_size = 18.0
                config.line_height = 1.1
                config.initial_cols = 80
                config.initial_rows = 30
                config.window_background_opacity = 0.9
                config.macos_window_background_blur = 20
                config.enable_tab_bar = false
                config.window_close_confirmation = 'NeverPrompt'

                return config
                '';
        };
        zsh = {
            enable = true;
            enableCompletion = true;
            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;
            antidote = {
                enable = true;
                plugins = [
                    "romkatv/powerlevel10k"
                ];
            };
            initContent = 
                let before = lib.mkOrder 500
                /* sh */
                ''
                INSTANT_PROMPT="''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
                if [[ -r $INSTANT_PROMPT ]]; then
                    source $INSTANT_PROMPT
                        fi
                        '';
            after = lib.mkOrder 1000 
                /* sh */
                ''
                if [[ -f ~/.p10k.zsh ]]; then
                    source ~/.p10k.zsh
                        fi
                        ''; in
                        lib.mkMerge [ before after ];
            shellAliases = {
                "cat" = "bat";
            };
        };
        zoxide = {
            enable = true;
            enableZshIntegration = true;
            options = [ "--cmd cd" ];
        };
        eza = {
            enable = true;
            enableZshIntegration = true;
            icons = "always";
        };
        bat = {
            enable = true;
        };
        nixvim = {
            enable = true;
            colorschemes.gruvbox = {
                enable = true;
            };
            opts = {
                autoindent = true;
                tabstop=4;
                expandtab = true;
                shiftwidth = 4;
                smarttab = true;
                number = true;
            };
            diagnostic.settings.virtual_lines = true;
            plugins = {
                autoclose.enable = true;
                lspconfig.enable = true;
                blink-cmp = {
                    enable = true;
                    settings.keymap = {
                        "<C-b>" = [
                            "scroll_documentation_up"
                                "fallback"
                        ];
                        "<C-e>" = [
                            "hide"
                        ];
                        "<C-f>" = [
                            "scroll_documentation_down"
                                "fallback"
                        ];
                        "<C-n>" = [
                            "select_next"
                                "fallback"
                        ];
                        "<C-p>" = [
                            "select_prev"
                                "fallback"
                        ];
                        "<C-space>" = [
                            "show"
                                "show_documentation"
                                "hide_documentation"
                        ];
                        "<Tab>" = [
                            "select_and_accept"
                        ];
                        "<S-j>" = [
                            "select_next"
                                "fallback"
                        ];
                        "<S-Tab>" = [
                            "snippet_backward"
                                "fallback"
                        ];
                        "<Tab-y>" = [
                            "snippet_forward"
                                "fallback"
                        ];
                        "<S-k>" = [
                            "select_prev"
                                "fallback"
                        ];
                    };

                };
            };
            lsp = {
                inlayHints.enable = true;
                /* C */
                servers.clangd.enable = true;
                /* PYTHON */
                servers.pyright.enable = true;
                /* NIX */
                servers.nixd.enable = true;
            };
        };
    };
# Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
}
