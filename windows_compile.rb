require 'find'

# Dir.glob('./src/*.rb').each { |path| puts path }

# Dir.foreach('./src') do |path|
#   puts path
# end

source_files = ['./src/start.rb']
Find.find('./src') do |file|
  next if !file.match(/.rb/) || file.match(/start.rb/)
  # puts file
  source_files << file
end
source_files << './data/default_dictionary.txt'
source_files << './tcltk --no-autoload --add-all-core --no-dep-run --output ./app.exe'

# puts "ocra #{source_files.join(' ')}"
print "ocra #{source_files.join(' ')}"

