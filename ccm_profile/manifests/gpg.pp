define ccm_profile::gpg (
  $ensure   = 'present',
  $key_id   = $title,
  $key_type = 'public',
) {

  $keys = lookup({
    'name'          => 'ccm_profile::gpg::keys',
    'default_value' => {},
  })

  gnupg_key { "${key_id}_${key_type}":
    ensure      => $ensure,
    key_id      => $key_id,
    key_type    => $key_type,
    key_content => $keys[$key_id][$key_type],
    user        => 'root',
  }

}
