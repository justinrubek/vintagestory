{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      perSystem = {
        pkgs,
        system,
        ...
      }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config.permittedInsecurePackages = [
            "dotnet-runtime-7.0.20"
          ];
        };
        packages = rec {
          vintagestory = pkgs.callPackage ./packages/vintagestory.nix {};
          default = vintagestory;
        };
      };
    };
}
