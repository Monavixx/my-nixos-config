{ inputs }:

final: prev: {
  libfprint-ft9362 = prev.libfprint.overrideAttrs (old: {
    version = "${old.version}-ft9362";

    src = inputs.libfprint-ft9362-src;
  });

  # Important: fprintd must use our modified libfprint.
  fprintd-ft9362 = prev.fprintd.override {
    libfprint = final.libfprint-ft9362;
  };
}
