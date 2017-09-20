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

* Prep Time: <% if prep_hours > 0 %><%= prep_hours %> hour<%='s' if prep_hours != 1 %><% end %><% if prep_minutes > 0 %><%= prep_minutes %> minute<%='s' if prep_minutes != 1 %><% end %>

<% if notes -%>
<%= notes %>

<% end -%>
## Ingredients:

<% ingredients.each do |ingredient| -%>
  * <%= ingredient %>
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