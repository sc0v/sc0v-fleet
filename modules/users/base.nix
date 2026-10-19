{ ... }:

{
  imports = [
    ./classes/sc0v-admins-sudo.nix
    ./service-accounts/deploy-nologin.nix
    ./ssh-key-policy.nix
  ];

  users.mutableUsers = false;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = true;
      PermitRootLogin = "no";
    };
  };
}
