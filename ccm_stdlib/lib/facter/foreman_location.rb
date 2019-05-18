require 'facter'
Facter.add(:foreman_location) do
  setcode do
    Facter.value(:ccm_dc)
  end
end
