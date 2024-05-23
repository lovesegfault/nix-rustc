{
  description = "Nix flake for rustc development";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
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
    };
}
