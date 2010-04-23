scenario "Change group" do
  executing "sudo chgrp everyone /tmp/foo" do 
    check '/tmp/foo', :changed_group => {:to => 'everyone'}
  end
end
