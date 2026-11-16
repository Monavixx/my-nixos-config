{ libfprint, src }:
libfprint.overrideAttrs (old: {
  version = "${old.version}-ft9362";
  inherit src;
})
