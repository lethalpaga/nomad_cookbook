#
# Cookbook: nomad
# License: Apache 2.0
#
require 'poise'

module NomadCookbook
  module Resource
    # A `nomad_config` resource for managing Nomad's configuration
    # files.
    # @action create
    # @provides nomad_config
    class NomadConfig < Chef::Resource
      include Poise(fused: true)
      provides(:nomad_config)

      # @!attribute path
      # The Nomad configuration file path.
      # @return [String]
      attribute(:path, kind_of: String, name_attribute: true)
      # @!attribute owner
      # The Nomad configuration file owner.
      # @return [String]
      attribute(:owner, kind_of: String, default: 'nomad')
      # @!attribute group
      # The Nomad configuration file group.
      # @return [String]
      attribute(:group, kind_of: String, default: 'nomad')

      # @see https:/nomadproject.io/docs/agent/config.html
      attribute(:region, kind_of: String)
      attribute(:datacenter, kind_of: String)
      attribute(:name, kind_of: String)
      attribute(:data_dir, kind_of: String)
      attribute(:log_level, kind_of: String)
      attribute(:bind_addr, kind_of: String)
      attribute(:enable_debug, kind_of: String)
      attribute(:ports, kind_of: [Hash, Mash])
      attribute(:addresses, kind_of: [Hash, Mash])
      attribute(:advertise, kind_of: [Hash, Mash])
      attribute(:consul, kind_of: [Hash, Mash])
      attribute(:atlas, kind_of: [Hash, Mash])
      attribute(:server, kind_of: [Hash, Mash])
      attribute(:client, kind_of: [Hash, Mash])
      attribute(:chroot_env, kind_of: [Hash, Mash])
      attribute(:telemetry, kind_of: [Hash, Mash])

      # Transforms the resource into a JSON format which matches the
      # Nomad service's configuration format.
      # @see https://nomadproject.io/docs/agent/config.html
      def to_json
        # top-level
        config_keeps = %i{data_dir}
        config = to_hash.keep_if do |k, _|
          config_keeps.include?(k.to_sym)
        end

        JSON.pretty_generate(config, quirks_mode: true)
      end

      action(:create) do
        notifying_block do
          directory ::File.dirname(new_resource.path) do
            recursive true
          end

          file new_resource.path do
            content new_resource.to_json
            owner new_resource.owner
            group new_resource.group
            mode '0640'
          end
        end
      end

      action(:remove) do
        notifying_block do
          file new_resource.path do
            action :delete
          end
        end
      end
    end
  end
end
