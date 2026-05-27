# flake based on
# https://github.com/NixOS/templates/blob/ad0e221dda33c4b564fad976281130ce34a20cb9/bash-hello/flake.nix
{
  description        = "My custom build of Iosevka";
  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";

  outputs = {nixpkgs, ...}: (
    let
      # confirmed to work on the following systems
      systems-linux    = ["x86_64-linux"  "aarch64-linux"];
      systems-darwin   = ["x86_64-darwin" "aarch64-darwin"];
      supportedSystems = systems-linux ++ systems-darwin;

      # helper function to generate an attrset
      # '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in {
      defaultPackage = forAllSystems(system:
        nixpkgs.legacyPackages.${system}.iosevka.override {
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
              digit-form = "old-style";
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
