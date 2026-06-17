# flake based on
# https://github.com/NixOS/templates/blob/ad0e221dda33c4b564fad976281130ce34a20cb9/bash-hello/flake.nix
{
  description                 = "My custom build of Iosevka";

  inputs.nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
  inputs.nixpkgs-darwin.url   = "nixpkgs/nixpkgs-25.11-darwin";
  inputs.nixpkgs-linux.url    = "nixpkgs/nixos-25.11";

  outputs = {nixpkgs-unstable,nixpkgs-darwin,nixpkgs-linux,...}: (
    let
      # confirmed to work on the following systems
      systems-linux    = ["x86_64-linux"  "aarch64-linux"];
      systems-darwin   = ["x86_64-darwin" "aarch64-darwin"];
      supportedSystems = systems-linux ++ systems-darwin;

      # helper function to generate an attrset
      # '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs-unstable.lib.genAttrs supportedSystems;

      get-nixpkgs-stable = system: (
        if      builtins.elem system systems-linux  then
          nixpkgs-linux
        else if builtins.elem system systems-darwin then
          nixpkgs-darwin
        else
          nixpkgs-unstable
      );
    in {
      defaultPackage = forAllSystems(system:
        (get-nixpkgs-stable system).legacyPackages.${system}.iosevka.override {
          set        = "Custom-Fixed-Slab-ExtraExtended";
          privateBuildPlan = {
            family  = "Iosevka Custom Fixed Slab Extra Extended";
            spacing = "fixed";
            serifs  = "slab";
            widths  = {
              "" = {
                shape = 650;
                menu  = 7;
                css   = "expanded";
              };
            };
            variants.design = {
              zero       = "unslashed";
              m          = "top-left-and-bottom-right-serifed";
              lower-chi  = "semi-chancery-straight-serifed";
            };
            exportGlyphNames = false;
          };
        }
      );
    }
  );
}
