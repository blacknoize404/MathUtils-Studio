{
  description = "MathUtils Studio: calculadora y solucionadores matemáticos paso a paso";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      # La licencia (propietaria, de uso gratuito) cuenta como no libre para Nix: este paquete se permite sin pedir --impure
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfreePredicate = pkg: nixpkgs.lib.getName pkg == "mathutils-studio";
          };
        in
        rec {
          mathutils-studio = pkgs.callPackage ./nix/package.nix { };
          default = mathutils-studio;
        }
      );

      # nix run github:blacknoize404/MathUtils-Studio
      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/mathutils-studio";
        };
      });

      # Para NixOS: nixpkgs.overlays = [ inputs.mathutils-studio.overlays.default ];
      overlays.default = final: _prev: {
        mathutils-studio = final.callPackage ./nix/package.nix { };
      };
    };
}
