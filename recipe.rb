class Recipe < Struct.new(:title, :ingredients, :prep_time, :steps, :servings, :category, :tags, :notes)
  def prep_hours
    prep_time / 60
  end

  def prep_minutes
    prep_time % 60
  end
end
