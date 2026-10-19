{ ... }:

{
  users.users = {
    "tbritogo" = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      hashedPassword = "!";
      openssh.authorizedKeys.keys = [
	"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINHE84GUQxaJ7namZHPJG0jc+xWurwcrY2wF7TNmsKX1 tomasbg1@icloud.com"
      ];
    };

    "meribyte" = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      hashedPassword = "!";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHEtyc6XHPy17ias7N0JG1d8u5AMjsieBSUomIiB44PM springcarnival.org"
      ];
    };
  };
}
