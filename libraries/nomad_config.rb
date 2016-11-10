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
      attribute(:addresses, kind_of: [Hash, Mash])
      attribute(:advertise, kind_of: [Hash, Mash])
      attribute(:atlas, kind_of: [Hash, Mash])
      attribute(:bind_addr, kind_of: String)
      attribute(:client, kind_of: [Hash, Mash])
      attribute(:consul, kind_of: [Hash, Mash])
      attribute(:datacenter, kind_of: String)
      attribute(:data_dir, kind_of: String)
      attribute(:disable_anonymous_signature, equal_to: [true, false])
      attribute(:disable_update_check, equal_to: [true, false])
      attribute(:enable_debug, equal_to: [true, false])
      attribute(:enable_syslog, equal_to: [true, false])
      attribute(:http_api_response_headers, kind_of: [Hash, Mash])
      attribute(:leave_on_interrupt, equal_to: [true, false])
      attribute(:leave_on_terminate, equal_to: [true, false])
      attribute(:log_level, kind_of: String)
      attribute(:node_name, kind_of: String)
      attribute(:ports, kind_of: [Hash, Mash])
      attribute(:region, kind_of: String)
      attribute(:server, kind_of: [Hash, Mash])
      attribute(:syslog_facility, kind_of: String)
      attribute(:tls, kind_of: [Hash, Mash])
      attribute(:vault, kind_of: [Hash, Mash])
      attribute(:telemetry, kind_of: [Hash, Mash])

      # Transforms the resource into a JSON format which matches the
      # Nomad service's configuration format.
      # @see https://nomadproject.io/docs/agent/config.html
      def to_json
        # top-level
        config_keeps = %i{ addresses advertise atlas bind_addr client consul
          datacenter data_dir disable_anonymous_signature disable_update_check
          enable_debug enable_syslog http_api_response_headers leave_on_interrupt
          leave_on_terminate log_level node_name ports region server syslog_facility
          tls vault telemetry
        }
        config = to_hash.keep_if do |k, _|
          config_keeps.include?(k.to_sym)
        end

        # The :name attribute is reserved by chef, so we store it in
        # :node_name and reaffect it if needed
        config[:name] = config[:node_name]
        config.delete(:name) unless config[:name]

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
