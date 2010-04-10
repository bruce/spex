command "echo 'foo' >> /tmp/foo"

scenario :default, "Modifies a file" do
  assert_modifies_file '/tmp/foo'
end
