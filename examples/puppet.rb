File.open('/tmp/spex-manifest.pp', 'w') do |f|
  f.puts %(file { "/tmp/foo": ensure => present })
end

scenario "Creates a file" do
  executing "puppet /tmp/spex-manifest.pp" do
    check '/tmp/foo', :created => true
  end
end
