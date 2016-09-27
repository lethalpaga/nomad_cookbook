#
# Cookbook: Nomad
# License: Apache 2.0
#
require 'poise_service/service_mixin'
require 'uri'

module NomadCookbook
  module Resource
    # A `nomada_service` resource for managing Nomad as a system
    # service.
    # @action enable
    # @action disable
    # @action start
    # @action stop
    # @action restart
    class NomadService < Chef::Resource
      include Poise
      provides(:nomad_service)
      include PoiseService::ServiceMixin

      # @!attribute config_path
      # The Nomad configuration file path.
      # @return [String]
      attribute(:config_path, kind_of: String, default: '/etc/nomad/nomad.json')
      # @!attribute directory
      # The directory to start the Nomad process.
      # @return [String]
      attribute(:directory, kind_of: String, default: '/var/run/nomad')
      # @!attribute user
      # The service user that Nomad process should run as.
      # @return [String]
      attribute(:user, kind_of: String, default: 'nomad')
      # @!attribute group
      # The service group the Nomad process should run as.
      # @return [String]
      attribute(:group, kind_of: String, default: 'nomad')
      # @!attribute environment
      # The environment the Nomad process should run with.
      # @return [String]
      attribute(:environment, kind_of: Hash, default: { PATH: '/usr/local/bin:/usr/bin:/bin' })
      # @!attribute program
      # The location of the Nomad executable.
      # @return [String]
      attribute(:program, kind_of: String, default: '/usr/local/bin/nomad')
    end
  end

  module Provider
    # A `nomad_service` provider for managing Nomad as a system
    # service.
    # @provides nomad_service
    class NomadService < Chef::Provider
      include Poise
      provides(:nomad_service)
      include PoiseService::ServiceMixin
      include NomadCookbook::Helpers

      def action_enable
        notifying_block do
          directory nomad_data_path do
            recursive true
            owner new_resource.user
            group new_resource.group
            mode '0750'
          end

          directory new_resource.directory do
            recursive true
            owner new_resource.user
            group new_resource.group
            mode '0750'
          end
        end
        super
      end

      def service_options(service)
        service.command("#{new_resource.program} agent -#{node['nomad']['mode']} -config=#{new_resource.config_path}")
        service.directory(new_resource.directory)
        service.user(new_resource.user)
        service.environment(new_resource.environment)
        service.restart_on_update(false)
        #service.options(:sysvinit, template: 'nomad:sysvinit.service.erb')
        #service.options(:systemd, template: 'nomad:systemd.service.erb')

        if node.platform_family?('rhel') && node.platform_version.to_i == 6
          service.provider(:sysvinit)
        end
      end
    end
  end
end
