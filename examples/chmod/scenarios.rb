command "chmod 700 /tmp/foo"

scenario :default, "Change mode" do
  assert_chmods_file '/tmp/foo', :to => 0700, :changes => true
end
