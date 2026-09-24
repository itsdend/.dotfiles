{ pkgs ? import <nixpkgs> { } }:

pkgs.callPackage (
  { lib, stdenv, fetchurl, autoPatchelfHook, zlib }:

  stdenv.mkDerivation rec {
    pname = "erlang-language-platform";
    version = "2026-06-10";

    src = fetchurl {
    url = "https://github.com/WhatsApp/erlang-language-platform/releases/download/${version}/elp-linux-x86_64-unknown-linux-gnu-otp-28.tar.gz";
    hash = "sha256-EERQlk2PQ9hSlNEG/Wpb9glLiK73qUaFrrcZc12Dn7c=";
    };
    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [ stdenv.cc.cc.lib zlib ];

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/bin
      cp elp $out/bin/
      chmod +x $out/bin/elp
    '';

    meta = with lib; {
      description = "Erlang Language Platform (ELP) - LSP server and CLI";
      homepage = "https://github.com/WhatsApp/erlang-language-platform";
      license = with licenses; [ asl20 mit ];
      platforms = [ "x86_64-linux" ];
    };
  }
) { }
