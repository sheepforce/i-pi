{
  description = "i-PI - a universal force engine ";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem
    (system:
      let
        overlay = import ./nix/overlay.nix;
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        };
      in
      {
        packages.default = pkgs.i-pi;

        devShells.default = with pkgs; mkShell {
          buildInputs = [
            nixpkgs-fmt
            black
          ]
          ++ python3.pkgs.i-pi.nativeBuildInputs
          ++ python3.pkgs.i-pi.buildInputs
          ++ python3.pkgs.i-pi.propagatedBuildInputs
          ;
        };
      }
    ) // {
    overlays.default = import ./nix/overlay.nix;
  };
}
