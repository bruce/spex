scenario "Change owner" do
  executing "sudo chown root /tmp/foo" do
    check '/tmp/foo', :changed_owner => {:to => 'root'}
  end
end
