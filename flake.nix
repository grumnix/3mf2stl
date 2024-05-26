{
  inputs = rec {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";

    convert_3mf2stl_src.url = "github:lemgandi/3mf2stl";
    convert_3mf2stl_src.flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, convert_3mf2stl_src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = rec {
          default = convert_3mf2stl;

          convert_3mf2stl = pkgs.stdenv.mkDerivation rec {
            pname = "3mf2stl";
            version = "1.0";
            src = convert_3mf2stl_src;
            checkPhase = ''
            make test
          '';
            installPhase = ''
            mkdir -p $out/bin/
            install 3mf2stl $out/bin/
            install convert_to_stl.sh $out/bin/convert_to_stl
          '';
            buildInputs = [
              pkgs.libzip
            ];

            meta = with pkgs.lib; {
              description = "Convert .3mf files to .stl files";

              longDescription = ''
                This is a simple command-line
                utility to convert 3d ".3mf" files to the ".stl" files
                used by most 3d printer slicing software.
              '';
              homepage = "https://github.com/lemgandi/3mf2stl";
              license = licenses.gpl3Plus;
              platforms = platforms.all;
            };
          };
        };
      }
    );
}
