{ lib, pkgs, ... }:

let
  andrew = list: "carnival-${list}@andrew.cmu.edu";

  forwards = {
    "booth@springcarnival.org" = [ (andrew "booth") ];
    "certificates@springcarnival.org" = [ (andrew "chair") (andrew "software") "merichar@merichar.org" ];
    "computer@springcarnival.org" = [ (andrew "software") ];
    "electrical@springcarnival.org" = [ (andrew "electrical") ];
    "entertainment@springcarnival.org" = [ (andrew "entertainment") ];
    "marketing@springcarnival.org" = [ (andrew "marketing") ];
    "operations@springcarnival.org" = [ (andrew "operations") ];
    "outreach@springcarnival.org" = [ (andrew "marketing") ];
    "sc0v@springcarnival.org" = [ (andrew "chair") ];
    "software@springcarnival.org" = [ (andrew "software") ];
    "treasurer@springcarnival.org" = [ (andrew "finance") ];
    "finance@springcarnival.org" = [ (andrew "finance") ];
    "youtube@springcarnival.org" = [ (andrew "chair") ];
    "itdirector@springcarnival.org" = [ (andrew "software") ];

    # Catch-all: everything else (typos, old addresses) goes to the chair list.
    "*" = [ (andrew "chair") ];
  };

  # lsearch* file: "address: target, target", with "*" as the default key.
  aliases = pkgs.writeText "springcarnival-forwards" (lib.concatStrings (lib.mapAttrsToList
    (address: targets: "${address}: ${lib.concatStringsSep ", " targets}\n")
    forwards));
in
{
  # Install as profiles/mail.springcarnival.org.nix in the parallel fleet.
  imports = [ ../modules/capabilities/exim.nix ];

  networking.firewall.allowedTCPPorts = [ 25 ];

  services.exim.config = ''
    primary_hostname = mail.springcarnival.org
    local_interfaces = <; 0.0.0.0 ; ::0
    domainlist local_domains = springcarnival.org : @
    hostlist relay_from_hosts = <; 127.0.0.1 ; ::1
    acl_smtp_rcpt = check_recipient

    begin acl

    check_recipient:
      accept hosts = +relay_from_hosts
      deny message = Relaying denied
           domains = ! +local_domains
      accept domains = +local_domains
             verify = recipient
      deny message = Unknown recipient

    begin routers

    forwards:
      driver = redirect
      domains = springcarnival.org
      data = ''${lookup{$local_part@$domain}lsearch*{${aliases}}}

    remote_dns:
      driver = dnslookup
      domains = ! +local_domains
      transport = remote_smtp
      no_more

    begin transports

    remote_smtp:
      driver = smtp
  '';
}
