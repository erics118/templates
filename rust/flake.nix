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
            config.treefmt.build.wrapper
            rustc
            cargo
            rustfmt
            clippy
            rust-analyzer
          ];
        };

        treefmt = {
          projectRootFile = "flake.nix";
          settings = {
            excludes = [ "target/**" ];
          };
          programs = {
            nixfmt.enable = true;
            rustfmt.enable = true;
            taplo.enable = true;
          };
        };

        formatter = config.treefmt.build.wrapper;
      };
    };
}
