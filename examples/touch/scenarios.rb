command 'touch /tmp/foo'

scenario :creation, "Creates a file" do
  assert_creates_file '/tmp/foo'
end
