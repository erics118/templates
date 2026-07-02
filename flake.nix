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
    inputs@{ flake-parts, self, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      imports = [ inputs.treefmt-nix.flakeModule ];

      flake.templates = {
        cpp = {
          path = ./cpp;
          description = "C++ project template";
        };
        latex = {
          path = ./latex;
          description = "LaTeX project template";
        };
        node = {
          path = ./node;
          description = "Node project template";
        };
        ocaml = {
          path = ./ocaml;
          description = "OCaml project template";
        };
        python = {
          path = ./python;
          description = "Python project template";
        };
        rust = {
          path = ./rust;
          description = "Rust project template";
        };
      };

      perSystem = { pkgs, config, ... }: {
        devShells.default = pkgs.mkShell { packages = [ config.treefmt.build.wrapper ]; };

        treefmt = {
          projectRootFile = "flake.nix";
          settings = {
            excludes = [ "templates/*/**" ];
          };
          programs = {
            nixfmt.enable = true;
            nixfmt.strict = true;
            statix.enable = true;
            deadnix.enable = true;
          };
        };

        formatter = config.treefmt.build.wrapper;

        checks.formatting = config.treefmt.build.check self;
      };
    };
}
