scenario "Change mode" do
  executing "chmod 700 /tmp/foo" do
    assert '/tmp/foo', :changed_mode => {:to => 0700}
  end
end
