{
  description = "A dev environment for dotnet";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        system = "${system}";
      };
    in {
      devShell = pkgs.mkShell {
        packages = with pkgs; [
          bashInteractive
          dotnetCorePackages.dotnet_8.sdk
          (vscode-with-extensions.override {
            vscode = vscodium;
            vscodeExtensions = with vscode-extensions; [
              ms-dotnettools.csdevkit
            ];
          })
        ];

        shellHook = ''
          exec codium --verbose .
        '';
      };
    }
  );

  devShells = {
    noIde = pkgs.mkShell {
      packages = with pkgs; [
        dotnetCorePackages.dotnet_8.sdk
      ];
    };
  };
}
