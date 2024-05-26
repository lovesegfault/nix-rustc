{
  description = "Nix flake for rustc development";

  nixConfig = {
    extra-trusted-substituters = [
      "https://rustc.cachix.org"
    ];
    extra-trusted-public-keys = [
      "rustc.cachix.org-1:8ydAwWnCrg7KmYsmw9XmGZ5DSIDGEe04YEWaLkW69Jk="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable-small";
    nix-fast-build = {
      url = "github:Mic92/nix-fast-build";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-github-actions = {
      url = "github:nix-community/nix-github-actions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-fast-build, nix-github-actions }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "x86_64-linux"
      ];
    in
    {
      devShells = forAllSystems (localSystem:
        let
          pkgs = import nixpkgs { inherit localSystem; };
        in
        {
          default = pkgs.callPackage ./rustc.nix { };
        }
      );


      packages = forAllSystems (localSystem: {
        inherit (nix-fast-build.packages.${localSystem}) nix-fast-build;
      });

      githubActions =
        let
          inherit (nixpkgs.lib) mapAttrs getAttrs;
          devShellPackages =
            mapAttrs
              (_: shells: mapAttrs (_: devShell: devShell.inputDerivation) shells)
              (getAttrs [ "x86_64-linux" ] self.devShells)
          ;
        in
        nix-github-actions.lib.mkGithubMatrix {
          checks = devShellPackages;
        };
    };
}
