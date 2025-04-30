{
  description = "J overlay";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs =
    { nixpkgs, self }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
      {
        overlays = {
          default = final: prev: import ./overlays final prev;
        };
      };
}
