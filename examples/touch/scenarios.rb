command 'touch /tmp/foo'

scenario :new, "Creates a file" do
  assert_creates '/tmp/foo'
end
