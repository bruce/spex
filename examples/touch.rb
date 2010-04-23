scenario "Creates a file" do
  executing "touch /tmp/foo" do
    check '/tmp/foo', :created => true
  end
end
