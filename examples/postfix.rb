# Note: We use the more specific 'postfix/master' as the process name so
# we don't confused with spex running this file (postfix.rb)
scenario "Postfix process management" do
  executing "sudo postfix start" do
    assert 'postfix/master', :started => true
  end
  executing "sudo postfix stop" do
    assert 'postfix/master', :stopped => true
  end
  executing "sudo postfix start" do
    assert 'postfix/master', :started => true
  end
  executing "sudo postfix stop && sudo postfix start" do
    assert 'postfix/master', :restarted => true
  end
end
