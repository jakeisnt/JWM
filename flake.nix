let
  name = "JWM";
  description = "Cross-platform window management and OS integration library for Java";
in
{
  inherit name description;

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
        xDependencies = with pkgs; with xorg; [
          xorgserver

          # development lib
          libX11

          # xorg input modules
          xf86inputevdev
          xf86inputsynaptics
          xf86inputlibinput

          # xorg video modules
          xf86videointel # may not be needed
          xf86videoati # may not be needed
          mesa

          # xf86videofbdev
          # xorg_sys_opengl

          # driversi686Linux.mesa

          # xf86videonouveau

          # unsure if needed
          # xf86videofbdev
          # xf86videoxgi
          # xf86videowsfb
          # xf86videovesa
          # xf86videovboxvideo
          # xf86videonv

          # dyn libs
          libXrandr
          libXcursor
          libXi
        ];
      in rec {
        devShells.default = pkgs.mkShell {
          inherit name description;
          nativeBuildInputs = with pkgs; [
            jdk17
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
