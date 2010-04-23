scenario "Modifies a file" do
  executing "echo 'foo' >> /tmp/foo" do
    check '/tmp/foo', :modified => true
  end
end
