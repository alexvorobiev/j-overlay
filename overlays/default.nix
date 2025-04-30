final: prev:
rec {
  j962 = (prev.callPackage ./j.nix { avx2Support = true; }).overrideAttrs (_: rec {
    version = "9.6.2";
    src =  prev.fetchFromGitHub {
      owner = "jsoftware";
      repo = "jsource";
      rev = "9.6.2";
      hash = "sha256-Afa2QzzgJYijcavurgGH/qwyofNn4rtFMIHzlqJwFGU=";
    };
  });

  j963 = (prev.callPackage ./j.nix { avx2Support = true; }).overrideAttrs (_: rec {
    version = "9.6.3";
    src =  prev.fetchFromGitHub {
      owner = "jsoftware";
      repo = "jsource";
      rev = "90dd14ddf3e7f3810e37398a810e59331a2c4305";
      hash = "sha256-QuFGqkwWdaewEkCq23Tn0yjfw5ATul89imkDHVy8YEw=";
    };
  });

  j970-beta3 = (prev.callPackage ./j.nix { avx2Support = true; }).overrideAttrs (_: rec {
    version = "9.7.0-beta3";
    src =  prev.fetchFromGitHub {
      owner = "jsoftware";
      repo = "jsource";
      rev = "25ad9ecd0e2494805d3ad1dbaad17f76da4fe3e4";
      hash = "sha256-SkDCvDRtmXYf1Do+ou1Nc0RRZnnZRCqhMNJ52pkbYS4=";
    };
  });

  jdev = prev.callPackage ./j.nix { avx2Support = true; };

  j = j962;
}
