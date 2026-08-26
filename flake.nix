{
  description = "My custom build of Iosevka";

  inputs.pins.url            = "github:anderslundstedt/nix-pins";
  inputs.flake-utils.follows = "pins/flake-utils";

  outputs = inputs@{...}:
    let
      # confirmed to work on the following systems
      systems-linux    = ["x86_64-linux"  "aarch64-linux"];
      systems-darwin   = ["aarch64-darwin"];
      supportedSystems = systems-linux ++ systems-darwin;
    in
      inputs.flake-utils.lib.eachSystem supportedSystems (system:
        let
          nixpkgs-stable =
            inputs.pins.nixpkgs-stable.${system}.legacyPackages.${system};
        in {
          packages.default = nixpkgs-stable.iosevka.override {
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
          };
        }
      );
}
