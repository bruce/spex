scenario "Change group" do
  executing "sudo chgrp everyone /tmp/foo" do 
    assert '/tmp/foo', :changed_group => {:to => 'everyone'}
  end
end
