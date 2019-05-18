require 'facter'

# This was my better regex with named capture groups but apparently those didnt exist in ruby 1.8 so I had to drop them
#    /((?<tier>\A[[:alpha:]]+)-)?(?<role>[[:alpha:]]*)[[:digit:]]*.(?<env>[[:alpha:]]+).(?<dc>[[:alnum:]]+)/
hostname_re = /((\A[[:alpha:]]+)-)?([[:alpha:]]*)[[:digit:]]*.([[:alpha:]]+).([[:alnum:]]+)/

hostname = Facter.value(:fqdn)
res = hostname_re.match(hostname)

# Tier
Facter.add :ccm_tier do
  setcode do
    res[2] || 'infra'
  end
end

# Role
Facter.add :ccm_role do
  setcode do
    res[3]
  end
end

# Env
Facter.add :ccm_env do
  setcode do
    res[4]
  end
end

# DC
Facter.add :ccm_dc do
  setcode do
    res[5]
  end
end
