{ ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader = {
    grub.enable = true;
  };

  networking.hostName = "ops-01";
  networking.domain = "springcarnival.org";

  system.stateVersion = "26.05";
}
