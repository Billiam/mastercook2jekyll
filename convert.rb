path = ARGV.first
usage = "\nUSAGE: ruby convert.rb <mastercook_file> <output directory>\n\n"

if ARGV.length != 2 || !File.readable?(ARGV[0]) || !File.directory?(ARGV[1])
  puts usage and return
end 

require_relative './master_cook_parser'
require_relative './jekyll_page'

recipes_file, output_directory = ARGV
recipe_data = File.read(recipes_file)

pages = MasterCookParser.parse(recipe_data).map { |recipe| JekyllPage.new(recipe) }
pages.each do |page|
  File.binwrite(File.join(output_directory, page.filename), page.content)
end