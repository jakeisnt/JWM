{
  description = "Cross-platform window management and OS integration library for Java";

  inputs = {
    nixpkgs.url     = github:nixos/nixpkgs/release-22.05;
    flake-utils.url = github:numtide/flake-utils;

    # Used for shell.nix
    flake-compat = {
      url = github:edolstra/flake-compat;
      flake = false;
    };
  };

  outputs = {self, nixpkgs, flake-utils, ...} @ inputs:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
        xDependencies = with pkgs; [
          xorg.xorgserver

          # development lib
          xorg.libX11

          # xorg input modules
          xorg.xf86inputevdev
          xorg.xf86inputsynaptics
          xorg.xf86inputlibinput

          # xorg video modules
          xorg.xf86videointel
          xorg.xf86videoati
          xorg.xf86videonouveau
        ];
      in rec {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            jdk11
          ] ++ xDependencies;

          buildInputs = with pkgs; [
            python3
            libGL
            ninja
            cmake
            gcc
          ];

          LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath (with pkgs; [ libGL ] ++ xDependencies)}:$LD_LIBRARY_PATH";
        };

        # For compatibility with older versions of the `nix` binary
        devShell = self.devShells.${system}.default;
      }
    );
}
