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
        # packages.x86_64-linux.foo = pkgs.writeShellScriptBin "foo" "echo -n 'I am a custom package'";

        overlays = {
          default = final: prev:  import ./overlays final prev;
        };

      #   checks.x86_64-linux.overlayTest = pkgs.testers.runNixOSTest {
      #     name = "overlayTest";

      #     node.pkgsReadOnly = false; # Option that is special for tests where machines need to change their nixpkgs

      #     nodes.machine1 = { pkgs, ... }: { # A module in the resulting system that is defined in line
      #       nixpkgs.overlays = [ self.overlays.default ];

      #       environment.systemPackages = [ pkgs.foo ];
      #     };

      #     testScript =
      #       # See the devmanual for available python methods:
      #       # https://nixos.org/manual/nixos/stable/#ssec-machine-objects
      #       ''
      #         assert machine.execute("foo")[1] == "I am a custom package"
      #       '';
      #   };
      };
}
