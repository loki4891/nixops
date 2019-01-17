{ config, lib, uuid, name, ... }:

with lib;

{
  options = {

    # Global vault options that can be migrated to a seperate file
    # if another resource is to be supported
    vaultToken = mkOption {
      default = "";
      type = types.str;
      description = "Vault token.";
    };

    vaultAddress = mkOption {
      default = "";
      example = "https://vault.nixops.com:8200";
      type = types.str;
      description = "Vault URL address.";
    };

    # Approle specific options
    roleName = mkOption {
      default = "vault-approle-${uuid}-${name}";
      type = types.str;
      description = "Approle name";
    };

    roleId = mkOption {
      default = "";
      type = types.str;
      description = "The Approle id generated from vault. This is set by vault.";
    };

    bindSecretId = mkOption {
      default = true;
      type = types.bool;
      description = "The Approle secret generated from vault, it can be set to false if bound_cidr_list is set.";
    };

    secretIdBoundCidrs = mkOption {
      default = [];
      type = types.listOf types.str;
      description = "List of CIDR blocks enforcing login from specific set of IP addresses.";
    };

    tokenBoundCidrs = mkOption {
      default = [];
      type = types.listOf types.str;
      description = ''
        List of CIDR blocks enforcing tokens generate by
        this role to be used from specific set of IP addresses.
      '';
    };

    policies = mkOption {
      default = [ "default" ];
      type = types.listOf types.str;
      description = "list of policies set on tokens issued via this AppRole.";
    };

    secretIdNumUses = mkOption {
      default = 0;
      type = types.int;
      description = ''
        Number of times any particular SecretID can be used to fetch
        a token from this AppRole, after which the SecretID will expire.
        A value of zero will allow unlimited uses.'';
    };

    secretIdTtl = mkOption {
      default = "0";
      type = types.str;
      description = ''
        Duration in either an integer number of seconds (3600) or an integer
        time unit (60m) after which any SecretID expires.
        Default "0" is infinit.'';
    };

    tokenNumUses = mkOption {
      default = 0;
      type = types.int;
      description = "Number of times issued tokens can be used. A value of 0 means unlimited uses.";
    };

    tokenMaxTtl = mkOption {
      default = "0";
      type = types.str;
      description = ''
        Duration in either an integer number of seconds (3600) or an integer time unit (60m)
        after which the issued token can no longer be renewed. Default is set to infinit'';
    };

    tokenTtl = mkOption {
      default = "3600";
      type = types.str;
      description = ''
        Duration in either an integer number of seconds (3600) or an integer time unit (60m)
        to set as the TTL for issued tokens and at renewal time. Default is set to 1 hour.'';
    };

    period = mkOption {
      default = "3600";
      type = types.str;
      description = ''
        Duration in either an integer number of seconds (3600) or an integer time unit (60m).
        If set, the token generated using this AppRole is a periodic token; so long as it is renewed
        it never expires, but the TTL set on the token at each renewal is fixed to the value specified here.
        If this value is modified, the token will pick up the new value at its next renewal.'';
    };

    enableLocalSecretIds = mkOption {
      default = false;
      type = types.bool;
      description = ''
        If true, the secret IDs generated using this role will be cluster local. This can only
        be set during role creation and once set, it can't be reset later.'';
    };

    tokenType = mkOption {
      default = "service";
      type = types.str;
      description = ''
        The type of token that should be generated via this role. Can be 'servic'e, 'batch', or
        'default' to use the mount's default (which unless changed will be 'service' tokens).'';
    };

    secretId = mkOption {
      default = "";
      type = types.str;
      description = "SecretID to be attached to the Role. This is set by NixOps";
    };

    cidrList = mkOption {
      default = [];
      type = types.listOf types.str;
      description = ''
        List of CIDR blocks enforcing secret IDs to be used from specific set of IP addresses.
        If bound_cidr_list is set on the role, then the list of CIDR blocks listed here should
        be a subset of the CIDR blocks listed on the role.'';
    };
  };
  config._type = "vault-approle";
}
