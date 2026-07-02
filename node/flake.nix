{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      imports = [ inputs.treefmt-nix.flakeModule ];

      perSystem = { pkgs, config, ... }: {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nodejs_26
            typescript-language-server
            tailwindcss-language-server
          ];
        };

        treefmt = {
          projectRootFile = "flake.nix";
          settings = {
            excludes = [
              "node_modules/**"
              "dist/**"
            ];
          };
          programs = {
            nixfmt.enable = true;
            prettier.enable = true;
          };
        };

        formatter = config.treefmt.build.wrapper;
      };
    };
}
