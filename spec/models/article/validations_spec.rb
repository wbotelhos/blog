require 'spec_helper'

describe Article, "validations" do
  it { should_not allow(nil).for(:title) }
  xit { should_not allow(nil).for(:categories) } # undefined method `each' for nil:NilClass
  it { should_not allow(nil).for(:user) }
  it { should_not allow(nil).for(:slug) }

  it { should allow("title").for(:title) }
  it { should allow("body").for(:body) }
  it { should allow("2012-05-29 13:09:00").for(:published_at) }
  it { should allow("slug").for(:slug) }
end
