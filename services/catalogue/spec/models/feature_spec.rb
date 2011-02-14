require 'spec_helper'

describe Feature do
  
  it "has an observation relationship" do
    feature = Factory(:feature)
    feature.feature_type.should_not be_nil    
    feature.feature_type.should be_kind_of(FeatureType)
  end

  it "has a feature attribute relationship" do
    feature = Factory(:feature)
    feature.feature_attributes.should_not be_nil
    feature.feature_attributes.count.should > 1
    feature.feature_attributes[0].should be_kind_of(FeatureAttribute)
  end
  
end
