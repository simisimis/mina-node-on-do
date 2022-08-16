{
  description = "node side up";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        do_api_token = builtins.readFile (builtins.toPath ("${builtins.getEnv("PWD")}/secrets/env"));
      in
      with pkgs;
      {
        devShells.default = mkShell {
          buildInputs = [
            terraform
            just
            zsh
          ];
          shellHook = ''
            cat <<EOF
            Development shell for starting mina node in Digital Ocean.

            $(just -l |sed 's/^Available recipes:/The following `just` recipes are available:/')
            EOF
            export DO_API_TOKEN=${do_api_token}
            exec zsh
          '';
        };

      }
    );
}
