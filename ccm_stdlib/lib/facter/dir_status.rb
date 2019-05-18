# 20130522 ic
# When we build a new server, we force-delete /opt and link /opt to /vol1
# and force-delete /home and link /home to /vol1
# But we also need to protect /opt and /home on legacy server

# Assumptions: 
# AppUID home directory should be created only after /home is a link
# A brand new CentOS build should have an empty /home
# RPM based on /opt should be installed only after /opt is a link
# A brand new CentOS build should only have /opt/rh

# Possible values are link, ok, legacy

# /opt
%x(test -L /opt)
if $?.exitstatus == 0
  #puts "/opt is already a link"
  Facter.add("opt_status") { setcode { "link" } }
else
  %x(test -d /opt)
  if $?.exitstatus == 1
    #puts "why is /opt a file? just kill it!"
    Facter.add("opt_status") { setcode { "ok" } }
  else
    %x(ls -1 /opt | egrep -q -v -e 'home|rh')
    if $?.exitstatus == 1
      #puts "safe to re-make /opt"
      Facter.add("opt_status") { setcode { "ok" } }
    else
      #puts "not safe to re-make /opt"
      Facter.add("opt_status") { setcode { "legacy" } }
    end
  end
end

# /home
%x(test -L /home)
if $?.exitstatus == 0
  #puts "/home is already a link"
  Facter.add("home_status") { setcode { "link" } }
else
  %x(test -d /home)
  if $?.exitstatus == 1
    #puts "why is /home a file? just kill it!"
    Facter.add("home_status") { setcode { "file" } }
  else
    line = %x(ls -1 /home | wc -l)
    if line.to_i == 0
      #puts "safe to re-make /home"
      Facter.add("home_status") { setcode { "empty" } }
    else
      #puts "not safe to re-make /home"
      Facter.add("home_status") { setcode { "occupied" } }
    end
  end
end
