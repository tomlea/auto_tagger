require File.dirname(__FILE__) + '/../spec_helper'

describe CapistranoHelper do

  describe ".new" do
    it "blows up if there are no stages" do
      proc do
        CapistranoHelper.new({})
      end.should raise_error(CapistranoHelper::NoStagesSpecifiedError)
    end
  end

  describe "#variables" do
    it "returns all variables" do
      CapistranoHelper.new({:stages => [:bar]}).variables.should == {:stages => [:bar]}
    end
  end

  describe "#stages" do
    it "returns the hashes' stages value" do
      CapistranoHelper.new({:stages => [:bar]}).stages.should == [:bar]
    end
  end

  describe "#working_directory" do
    it "returns the hashes' working directory value" do
      CapistranoHelper.new({:stages => [:bar], :working_directory => "/foo"}).working_directory.should == "/foo"
    end
    
    it "defaults to Dir.pwd if it's not set, or it's nil" do
      mock(Dir).pwd { "/bar" }
      CapistranoHelper.new({:stages => [:bar]}).working_directory.should == "/bar"
    end
  end

  describe "#current_stage" do
    it "returns the hashes' current stage value" do
      CapistranoHelper.new({:stages => [:bar], :current_stage => :bar}).current_stage.should == :bar
      CapistranoHelper.new({:stages => [:bar]}).current_stage.should be_nil
    end
  end

  describe "#previous_stage" do
    it "returns the previous stage if there is more than one stage, and there is a current stage" do
      CapistranoHelper.new({:stages => [:foo, :bar], :current_stage => :bar}).previous_stage.should == :foo
    end

    it "returns nil if there is no previous stage" do
      CapistranoHelper.new({:stages => [:bar], :current_stage => :bar}).previous_stage.should be_nil
    end

    it "returns nil if there is no current stage" do
      CapistranoHelper.new({:stages => [:bar]}).previous_stage.should be_nil
    end
  end

  describe "#branch" do
    describe "with :head and :branch specified" do
      it "returns master" do
        variables = {
          :stages => [:bar],
          :head => nil,
          :branch => "foo"
        }
        CapistranoHelper.new(variables).branch.should == "foo"
      end
    end

    describe "with :head specified, but no branch specified" do
      it "returns master" do
        variables = {
          :stages => [:bar],
          :head => nil
        }
        CapistranoHelper.new(variables).branch.should == nil
      end
    end

    describe "with :branch specified" do
      it "returns the value of branch" do
        variables = {
          :stages => [:bar],
          :branch => "foo"
        }
        CapistranoHelper.new(variables).branch.should == "foo"
      end
    end

    describe "with a previous stage with a tag" do
      it "returns the latest tag for the previous stage" do
        variables = {
          :stages => [:foo, :bar],
          :current_stage => :bar,
          :branch => "master",
          :working_directory => "/foo"
        }
        tagger = Object.new
        mock(tagger).latest_tag { "foo_01" }
        mock(AutoTagger).new(:foo, "/foo") { tagger }
        CapistranoHelper.new(variables).branch.should == "foo_01"
      end
    end

    describe "with no branch and a previous stage with no tag" do
      it "returns nil" do
        variables = {
          :stages => [:foo, :bar],
          :current_stage => :bar,
          :working_directory => "/foo"
        }
        tagger = Object.new
        mock(tagger).latest_tag { nil }
        mock(AutoTagger).new(:foo, "/foo") { tagger }
        CapistranoHelper.new(variables).branch.should == nil
      end
    end

    describe "with no branch and previous stage" do
      it "returns nil" do
        variables = {
          :stages => [:bar],
          :current_stage => :bar
        }
        CapistranoHelper.new(variables).previous_stage.should be_nil
        CapistranoHelper.new(variables).branch.should == nil
      end
    end
  end

end