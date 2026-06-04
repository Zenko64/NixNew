# Custom Module Namespace
{ lib, ... }:
{
  options.namespace = lib.mkOption {
    type = lib.types.str;
    default = "local";
    description = "Namespace that holds all module options.";
  };
}
