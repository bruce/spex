scenario "Modifies a file" do
  executing "echo 'foo' >> /tmp/foo" do
    assert '/tmp/foo', :modified => true
  end
end
