require "cap-aws-ec2/version"
require 'aws-sdk-core'

class CapAwsEc2

  Instance = Struct.new(:dns, :roles)

  def self.define_servers
    instances = CapAwsEc2.new(fetch(:aws_key_id), fetch(:secret_access_key), fetch(:aws_region), fetch(:ec2_project), fetch(:ec2_env)).execute
    instances.each do |s| 
      server s.dns, roles: s.roles, user: fetch(:user)
    end
  end

  def initialize(key, secret, aws_region, project, environment)
    @key = key
    @secret = secret
    @region = aws_region
    @project = project.to_s
    @environment = environment.to_s
  end

  def execute
    instances = ec2.describe_instances(instance_ids: tagged_instances,
                                       filters: [
                                         {name: "instance-state-name", values: ["running"]},
                                         {name: "tag:Env", values: [@environment]},
                                         {name: "tag:Project", values: [@project]},
                                         {name: "tag-key", values: ["Roles"]}
                                        ]
                                      )
    instances = instances.reservations.map {|r| r.instances }.flatten

    server_definitions(instances)
  end

  private

  def ec2
    @ec2 ||= begin
              Aws.config = { access_key_id: @key,
                             secret_access_key: @secret,
                             region: @region }
              Aws::EC2::Client.new
             end
  end

  def tagged_instances
    tags = ec2.describe_tags({filters: [
      {name: "resource-type", values: ["instance"]},
      {name: "key", values: ["Project"]}]
    })

    tags.tags.map(&:resource_id)
  end

  def server_definitions(instances)
    instances.map {|i| make_args(i)}
  end

  def make_args(instance)
    dns = instance.public_dns_name
    roles_tag = instance.tags.find {|t| t.key == "Roles"}.value
    roles = roles_tag.split(/,|;/)
    Instance.new(dns, roles)
  end

end
