{ lib, ... }:

{
  services.exim = {
    enable = true;

    # Local applications submit mail over loopback or with the Exim command.
    # Hosts requiring a smarthost can replace this configuration in their profile.
    config = lib.mkDefault ''
      local_interfaces = <; 127.0.0.1 ; ::1
      hostlist relay_from_hosts = <; 127.0.0.1 ; ::1
      acl_smtp_rcpt = check_recipient

      begin acl

      check_recipient:
        accept hosts = +relay_from_hosts
        deny message = Relaying denied

      begin routers

      remote_dns:
        driver = dnslookup
        domains = ! @
        transport = remote_smtp
        no_more

      begin transports

      remote_smtp:
        driver = smtp
    '';
  };
}
