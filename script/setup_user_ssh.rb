def prompt(msg)
  print "#{msg} "
  gets.chomp
end

def prompt?(msg)
  prompt("#{msg} (y/N)").match(/y|Y/)
end

username = prompt("Username:")
pub_key = prompt("SSH public key:")

puts "Username: #{username}"
puts "SSH public key: #{pub_key}"

exit 1 unless prompt? "Does this look correct?"

system("ssh max@meow.town 'sudo mkdir /home/#{username}/.ssh'")
system("ssh max@meow.town 'echo \'#{pub_key}\' | sudo tee /home/#{username}/.ssh/authorized_keys'")
system("ssh max@meow.town 'sudo chown -R #{username} /home/#{username}/.ssh'")
system("ssh max@meow.town 'sudo chmod 700 /home/#{username}/.ssh'")
system("ssh max@meow.town 'sudo chmod 644 /home/#{username}/.ssh/authorized_keys'")

puts "Done."

exit 0
