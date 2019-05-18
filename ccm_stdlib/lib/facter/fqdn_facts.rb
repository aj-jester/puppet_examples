require 'facter'

# <tier>-<role>-<id>.<fqdn_env>.<fqdn_location>.<fqdn_tld>
# On-Prem: consul-server-1.ops.iad1.ccmteam.com
# Cloud: consul-server-1.sandbox-dev.g-us-east-4.ccmteam.com

hostname = Facter.value(:fqdn)
hostname_split = hostname.split(".", 4)
hostname_tier_role_split = hostname_split.first.split("-") # <tier>-<role>-<id>

fqdn_env_split = hostname_split[1].split("-") # <fqdn_env>

fqdn_location = hostname_split[2] # <fqdn_location>
fqdn_location_split = fqdn_location.split("-")

# Tier
Facter.add :fqdn_tier do
  setcode do
    hostname_tier_role_split[0]
  end
end

# Role
Facter.add :fqdn_role do
  setcode do
    hostname_tier_role_split[1]
  end
end

# ID
Facter.add :fqdn_id do
  setcode do
    hostname_tier_role_split[2]
  end
end

# Env
# If array size is larger than 1 then its a cloud FQDN (sandbox-dev)
if fqdn_env_split.size > 1

  # Infra Env
  Facter.add :infra_env do
    setcode do
      fqdn_env_split[0]
    end
  end

  # App Env
  Facter.add :app_env do
    setcode do
      fqdn_env_split[1]
    end
  end

elsif fqdn_env_split.size == 1
  # If array size is only 1 element its a on-prem FQDN
  # App Env
  Facter.add :app_env do
    setcode do
      fqdn_env_split[0]
    end
  end
end


# If array size is larger than 1 then its a cloud FQDN (g-us-east-4)
if fqdn_location_split.size > 1
  # Provider (g)
  Facter.add :fqdn_provider do
    setcode do
      fqdn_location_split[0]
    end
  end

  # fqdn_pop; Point-of-Presence (us-east)
  Facter.add :fqdn_pop do
    setcode do
      fqdn_location_split[1] + "-" + fqdn_location_split[2]
    end
  end

  # fqdn_region (us-east-4)
  Facter.add :fqdn_region do
    setcode do
      fqdn_location_split[1] + "-" + fqdn_location_split[2] + "-" + fqdn_location_split[3]
    end
  end

end

# Location
Facter.add :fqdn_location do
  setcode do
    fqdn_location
  end
end

# Default Location
Facter.add :fqdn_default_location do
  setcode do
    hostname_split[2] == 'vbox' ? 'iad1' : hostname_split[2]
  end
end

# TLD
Facter.add :fqdn_tld do
  setcode do
    hostname_split[3]
  end
end
