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
            ocaml
            opam
            dune_3
            ocamlPackages.ocaml-lsp
            ocamlPackages.ocamlformat
            ocamlPackages.utop
            ocamlPackages.ounit2
            ocamlPackages.ppxlib
            ocamlPackages.bisect_ppx
          ];
        };

        treefmt = {
          projectRootFile = "flake.nix";
          settings = {
            excludes = [ "_build/**" ];
          };
          programs = {
            nixfmt.enable = true;
            ocamlformat.enable = true;
          };
        };

        formatter = config.treefmt.build.wrapper;
      };
    };
}
