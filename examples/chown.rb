scenario "Change owner" do
  executing "sudo chown root /tmp/foo" do
    assert '/tmp/foo', :changed_owner => {:to => 'root'}
  end
end
