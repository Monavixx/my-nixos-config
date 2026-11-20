{ den, inputs, lib, ... }:
let
  settingsType =
    let
      inherit (lib) mkOption types;
      inherit (den.lib.aspects.fx.keyClassification) isStructuralKey;

      skipKey = key:
        isStructuralKey key
        || (den.classes or { }) ? ${key}
        || (den.quirks or { }) ? ${key};

      reshape = raw:
        if raw ? options || raw ? config || raw ? imports then
          raw
        else
          { options = raw; };

      hasSettingsDeep = node:
        builtins.isAttrs node
        && (node ? settings
          || lib.any (key: !(skipKey key) && hasSettingsDeep (node.${key} or null)) (
            builtins.attrNames node
          ));

      nodeModule = node:
        let
          own = reshape (node.settings or { });
          children = lib.filterAttrs (
            key: value: !(skipKey key) && builtins.isAttrs value && hasSettingsDeep value
          ) node;
        in
        {
          imports = own.imports or [ ];
          config = own.config or { };
          options = (own.options or { }) // lib.mapAttrs (
            name: child:
            mkOption {
              type = types.submodule (nodeModule child);
              default = { };
              description = "Settings under ${name}";
            }
          ) children;
        };
    in
    types.submodule (nodeModule (den.aspects or { }));
in
{
  den.reservedKeys = [ "settings" ];

  den.schema.host.includes = [
    den.batteries.mutual-provider
    den.batteries.user-aspects
    den.aspects.home-manager
  ];
  den.schema.host.imports = [
    {
      options.settings = lib.mkOption {
        type = settingsType;
        default = { };
        description = "Per-aspect typed settings for this host.";
      };
    }
  ];
  den.schema.host.home-manager.module = inputs.home-manager.nixosModules.home-manager;
}
