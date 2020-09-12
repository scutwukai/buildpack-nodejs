require_relative "../spec_helper"

describe "Stack Changes" do
  #Test upgrading stack invalidates the cache
  it "should not restore cached directories" do
    app = Hatchet::Runner.new("default-node", allow_failure: true, stack: "heroku-18").setup!
    app.deploy do |app, heroku|
      app.update_stack("heroku-16")
      run!('git commit --allow-empty -m "heroku-16 migrate"')
      app.push!
      expect(app.output).to include("Cached directories were not restored due to a change in version of node, npm, yarn or stack")
    end
  end

#Test cache for regular deploys is used on repeated deploys
  it "should not restore cache if the stack did not change" do
    app = Hatchet::Runner.new('default-node', stack: "heroku-16").setup!
    app.deploy do |app, heroku|
      app.update_stack("heroku-16")
      run!('git commit --allow-empty -m "cedar migrate"')
      app.push!
      expect(app.output).to_not include("Cached directories were not restored due to a change in version of node, npm, yarn or stack")
      expect(app.output).to include("not cached - skipping")
    end
  end
end
