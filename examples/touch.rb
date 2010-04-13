scenario "Creates a file" do
  executing "touch /tmp/foo" do
    assert '/tmp/foo', :created => true
  end
end
