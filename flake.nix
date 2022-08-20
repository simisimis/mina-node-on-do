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
        do_api_token = builtins.readFile (builtins.toPath ("${builtins.getEnv("PWD")}/secrets/do_token"));
      in
      with pkgs;
      {
        devShells.default = mkShell {
          buildInputs = [
            terraform
            ansible
            just
            zsh
          ];
          shellHook = ''
            cat <<EOF
            Development shell for starting mina node(s) in Digital Ocean.

            $(just -l |sed 's/^Available recipes:/The following `just` recipes are available:/')
            EOF
            export TF_VAR_do_token=${do_api_token}
            exec zsh
          '';
        };

      }
    );
}
