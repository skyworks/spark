
def run(cmd)
  system 'echo ' + cmd 
  system cmd 
end

run 'git checkout .'
puts 'git pull origin master'
ret = `git pull origin master`
puts ret 

replace = {}
File.open("server_db.config") do |fr|
  while(line = fr.gets) 
    splits = line.split(':')
    replace[splits[0]] = splits[1].strip!
  end 
end

File.open("config/database.yml") do |fr|
  buffer = fr.read
  replace.each do |key, value|
    buffer.gsub!(/#{key}/, value)
  end 
  File.open("config/database.yml", "w") { |fw| fw.write(buffer) }
end

run 'bundle install'

puts ARGV

if ret.include? "Already up-to-date" and (ARGV.length == 0 or ARGV[0] != 'force')
  puts 'no new code update'
else
  run "rake db:migrate"
  run "rake db:test:prepare"
  ret = `rspec spec`
  puts ret 
  if ret.include? "0 failures"
    run "rake db:migrate RAILS_ENV=production"
    run "RAILS_ENV=production bundle exec rake assets:precompile"
    run "thin restart -s3 -O  --socket /tmp/thin.sock -e production"
  else
    puts 'test fail'
  end
end 
