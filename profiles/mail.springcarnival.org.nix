{ ... }:

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

    # Add a router like this for each public forwarding address.
    carnival_chairs:
      driver = redirect
      domains = springcarnival.org
      local_parts = sc0v
      data = carnival-chairs@andrew.cmu.edu

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
