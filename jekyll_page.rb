require 'erb'

class JekyllPage
  attr_reader :recipe

  def initialize(recipe)
    @recipe = recipe
  end

  def template
  <<-EOERB
---
title: <%= title %>
category: <%= category %>
<% if tags -%>
tags: 
<% tags.each do |tag| -%>
  - <%= tag.downcase %>
<% end -%>
<% end -%>
---
# <%= title %>

<% if servings -%>
* Servings: <%= servings %>
<% end -%>

* Prep Time: <%= formatted_prep_time %>

<% if notes -%>
<%= notes %>

<% end -%>
## Ingredients:

<% parsed_ingredients.each do |ingredient| -%>
<%= ingredient.quantity %> | <%= ingredient.item %>
<% end -%>

## Directions:

<% steps.each.with_index do |step, index| -%>
<%= index + 1 %>. <%= step %>
<% end %>
  EOERB
  end

  def content
    ERB.new(template, nil, '-').result(@recipe.instance_eval { binding })
  end

  def filename
    recipe.title.strip.downcase.gsub(/'/,'').gsub(/[^a-z0-9]+/i, '-') + '.md'
  end
end
