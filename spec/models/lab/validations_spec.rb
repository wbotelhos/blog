require "spec_helper"

describe Lab, "validations" do
  it { should_not allow(nil).for(:name) }
  it { should_not allow(nil).for(:slug) }

  it { should allow("name").for(:name) }
  it { should allow("slug").for(:slug) }
  it { should allow("description").for(:description) }

  context "uniqueness name" do
    let!(:plugin) {
      Plugin.create!({ :name => "name", :slug => "slug" })
    }

    it { should_not allow(plugin.name).for(:name) }
    it { should_not allow(plugin.slug).for(:slug) }
  end
end
