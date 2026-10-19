{ config, inputs, ... }:

{
  sops.age.keyFile = "/var/lib/sops-age/identity.txt";
  sops.defaultSopsFile = inputs."sc0v-fleet-secrets"
    + "/hosts/${config.networking.fqdn}.yaml";
}
