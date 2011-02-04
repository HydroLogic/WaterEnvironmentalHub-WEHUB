Factory.define :item  do |i|
  i.name "test item name"
  i.uuid "3068e840-2fe6-11e0-91fa-0800200c9a66"
  i.description "test description"
  i.methodology "test methodology"
end

Factory.define :item_fully_loaded, :class => Item do |i|
  i.association :item_group  
  i.features { |f| [f.association(:feature), f.association(:feature)] }
end

Factory.define :item_group do |g|
  g.name "test group"
  g.association :item, :factory => :item
end

Factory.define :feature do |f|
  f.sequence(:name) { |n| "test feature name #{n}}}" }
  f.sequence(:location) { |n| "test feature location #{n}}}" }
  f.association :observation, :factory => :observation
  f.feature_attributes { |f| [f.association(:feature_attribute), f.association(:feature_attribute)] }
end

Factory.define :observation do |o|
  o.json "{{'sample_json': true}}"
end

Factory.define :feature_attribute do |f|
  f.name "test feature attribute name"
  f.location "test feature attribute location"
end
