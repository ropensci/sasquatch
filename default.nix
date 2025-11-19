let
  pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/6e6b74474a97ebb70054f19d849f12250182560b.tar.gz") { };

  saspySrc = pkgs.fetchPypi {
    pname = "saspy";
    version = "5.104.0";
    sha256 = "sha256-MkCJRrBUCV23C7xls7Hl9HjDFy5kTx4PjZ/fDT67GK8=";
  };

  saspyPkg =
    pkgs.python312Packages.buildPythonPackage {
      pname = "saspy";
      version = "5.104.0";
      src = saspySrc;

      pyproject = true;

      build-system = [
        pkgs.python312Packages.setuptools
      ];

      propagatedBuildInputs = [
        pkgs.python312Packages.pandas
      ];

      postInstall = ''
        pkgDir=$out/${pkgs.python312.sitePackages}/saspy
        mkdir -p "$pkgDir/java/iomclient"
        cp ${./nix_setup/jars}/sas.rutil.jar "$pkgDir/java/iomclient/"
        cp ${./nix_setup/jars}/sas.rutil.nls.jar "$pkgDir/java/iomclient/"
        cp ${./nix_setup/jars}/sastpj.rutil.jar "$pkgDir/java/iomclient/"

        cp ${./nix_setup}/sascfg_personal.py "$pkgDir/"
      '';
    };

  pyconf = [
    pkgs.python312Packages.pip
    pkgs.python312Packages.ipykernel
    pkgs.python312Packages.pandas
    pkgs.python312Packages.wheel
    saspyPkg
  ];

  rpkgs = builtins.attrValues {
    inherit (pkgs.rPackages)
      cli
      curl
      devtools
      evaluate
      htmlwidgets
      knitr
      rcmdcheck
      reticulate
      rlang
      rmarkdown
      roxygen2
      rstudioapi
      testthat
      withr;
  };

  system_packages = builtins.attrValues {
    inherit (pkgs)
      glibcLocales nix openjdk17 python312 R quarto;
  };

in
{
  shell = pkgs.mkShell {
    LOCALE_ARCHIVE =
      if pkgs.stdenv.hostPlatform.system == "x86_64-linux"
      then "${pkgs.glibcLocales}/lib/locale/locale-archive"
      else "";

    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";

    RETICULATE_PYTHON = "${pkgs.python312}/bin/python";
    JAVA_HOME = pkgs.openjdk17;

    buildInputs = rpkgs ++ pyconf ++ system_packages;
  };
}
