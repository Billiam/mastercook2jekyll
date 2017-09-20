require_relative './recipe'

module MasterCookParser
  extend self

  def parse(content)
    recipes = content.split(/\* +Exported from *MasterCook +\*/)

    recipes.map(&:strip).reject(&:empty?).map{|recipe| parse_recipe(recipe) }
  end

  def recipe_regex
    %r{
      \A(?<title>.+)\n+
      (?:Recipe.+\n+)?
      Serving[ ]Size\s*:\s*(?<serving_size>\d+)\s+
        Preparation[ ]Time\s*:((?<prep_hours>\d+):(?<prep_minutes>\d+))\n+
      Categories\s*:\s*(?<categories>[\w\s]+)\n+
      \s*Amount.*\n
      \s*-+.*\n
      (?<ingredients>(.|\n)+?)\n\n
      (?<steps>(.|\n)*?)\n\n
      ((?:.*)\n\n
      NOTES\s*:\s*(?<notes>.*))?
    }x
  end

  def parse_recipe(data)
    recipe = Recipe.new
    
    results = recipe_regex.match(data)

    raise "Could not parse: #{data}" unless results
    
    recipe.title = results['title']
    recipe.servings = results['serving_size']
    recipe.notes = results['notes']
    if results['prep_minutes'] && results['prep_hours']
      recipe.prep_time = results['prep_hours'].to_i * 60 + results['prep_minutes'].to_i
    end

    categories = results['categories'].split(/  +/).map(&:strip).reject(&:empty?)

    recipe.category = categories.shift
    recipe.tags = categories

    recipe.ingredients = results['ingredients'].split(/\n+/).map(&:strip).reject(&:empty?).map do |ingredient|
      ingredient.gsub(/ +/, ' ').gsub(/(^\d+)\s+Unit/, '\1')
    end
    recipe.steps = results['steps'].gsub(/^(\d+\)|\*)\s*/, '').split(/\n+/).map(&:strip).reject(&:empty?)

    recipe
  end
end
