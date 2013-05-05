require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  before :each do
    @cli = Tugboat::CLI.new
  end

  describe "start" do
    it "starts the droplet with a fuzzy name" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
        to_return(:status => 200, :body => fixture("show_droplets"))
      stub_request(:put, "https://api.digitalocean.com/droplets/100823/power_on?api_key=#{api_key}&client_id=#{client_key}").
        to_return(:status => 200, :body => fixture("show_droplet"))

      @cli.start("foo")

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 100823 (foo)
Queuing start for 100823 (foo)...done
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
      expect(a_request(:put, "https://api.digitalocean.com/droplets/100823/power_on?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end

    it "starts the droplet with an id" do
      stub_request(:get, "https://api.digitalocean.com/droplets/#{droplet_id}?api_key=#{api_key}&client_id=#{client_key}").
       to_return(:status => 200, :body => fixture("show_droplet"))
      stub_request(:put, "https://api.digitalocean.com/droplets/100823/power_on?api_key=#{api_key}&client_id=#{client_key}").
       to_return(:status => 200, :body => fixture("show_droplet"))

      @cli.options = @cli.options.merge(:id => droplet_id)
      @cli.start

      expect($stdout.string).to eq <<-eos
Droplet id provided. Finding Droplet...done\e[0m, 100823 (foo)
Queuing start for 100823 (foo)...done
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets/#{droplet_id}?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
      expect(a_request(:put, "https://api.digitalocean.com/droplets/100823/power_on?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end


    it "starts the droplet with a name" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
        to_return(:status => 200, :body => fixture("show_droplets"))
      stub_request(:put, "https://api.digitalocean.com/droplets/100823/power_on?api_key=#{api_key}&client_id=#{client_key}").
        to_return(:status => 200, :body => fixture("show_droplet"))

      @cli.options = @cli.options.merge(:name => droplet_name)
      @cli.start

      expect($stdout.string).to eq <<-eos
Droplet name provided. Finding droplet ID...done\e[0m, 100823 (foo)
Queuing start for 100823 (foo)...done
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
      expect(a_request(:put, "https://api.digitalocean.com/droplets/100823/power_on?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end
  end
end