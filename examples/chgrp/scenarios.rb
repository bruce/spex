command "sudo chgrp everyone /tmp/foo"

scenario :default, "Change group" do
  assert_chgrps_file '/tmp/foo', :to => 'everyone', :changes => true
end
