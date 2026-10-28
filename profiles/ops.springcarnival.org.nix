{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../modules/capabilities/podman.nix
    ../modules/capabilities/nginx.nix
  ];
  security.acme.certs."ops.springcarnival.org".email = "certificates@springcarnival.org";
  services.nginx.virtualHosts."ops.springcarnival.org" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:3000";
      proxyWebsockets = true;
    };
  };
}
