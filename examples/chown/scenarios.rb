command "sudo chown root /tmp/foo"

scenario :default, "Change owner" do
  assert_chowns_file '/tmp/foo', :to => 'root', :changes => true
end
