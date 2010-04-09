command 'puppet %s'

scenario :creation, "Creates a file" do
  assert_creates '/tmp/foo'
end
