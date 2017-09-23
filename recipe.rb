class Recipe < Struct.new(:title, :ingredients, :prep_time, :steps, :servings, :category, :tags, :notes)
  def prep_hours
    prep_time / 60
  end

  def prep_minutes
    prep_time % 60
  end

  def formatted_prep_time
    [prep_duration('hour', prep_hours), prep_duration('minute', prep_minute)].reject(&:nil?).join(' ')
  end

  private
  def prep_duration(word, count)
    "#{word} #{plural(word, count)}" if count > 0
  end

  def plural(word, count)
    return word unless count == 1
    "#{word}s"
  end
end
