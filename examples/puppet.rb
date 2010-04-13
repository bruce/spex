File.open('/tmp/spex-manifest.pp', 'w') do |f|
  f.puts %(file { "/tmp/foo": ensure => present })
end

scenario "Creates a file" do
  executing "puppet /tmp/spex-manifest.pp" do
    assert '/tmp/foo', :created => true
  end
end
