Ingredient = Struct.new(:quantity, :item)
class Recipe < Struct.new(:title, :ingredients, :prep_time, :steps, :servings, :category, :tags, :notes)
  def prep_hours
    prep_time / 60
  end

  def prep_minutes
    prep_time % 60
  end

  def formatted_prep_time
    [prep_duration('hour', prep_hours), prep_duration('minute', prep_minutes)].reject(&:nil?).join(' ')
  end


  def parsed_ingredients
    ingredients.map do |data|
      match = data.match(/([\d \/]+(?: g|c|oz|t|T|qt|pinch|dash)?)(?: )(.*)/)

      ingredient = Ingredient.new
      if match
        ingredient.quantity, ingredient.item = match.captures
      else
        ingredient.item = data
      end

      ingredient
    end
  end

  private
  def prep_duration(word, count)
    "#{count} #{plural(word, count)}" if count > 0
  end

  def plural(word, count)
    return word if count == 1
    "#{word}s"
  end

end
