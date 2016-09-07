#
# Cookbook: nomad
#
require 'poise'

module NomadCookbook
  module Provider
    # A `nomad_installation` provider which manages Nomad binary
    # installation from remote source URL.
    # @action create
    # @action remove
    # @provides nomad_installation
    # @example
    #   nomad_installation '0.4.1'
    class NomadInstallationBinary < Chef::Provider
      include Poise(inversion: :nomad_installation)
      provides(:binary)
      inversion_attribute('nomad')

      # @api private
      def self.provides_auto?(_node, _resource)
        true
      end

      # Set the default inversion options.
      # @return [Hash]
      # @api private
      def self.default_inversion_options(node, new_resource)
        archive_basename = binary_basename(node, new_resource)
        super.merge(
          version: new_resource.version,
          archive_url: default_archive_url % { version: new_resource.version, basename: archive_basename },
          archive_basename: archive_basename,
          archive_checksum: binary_checksum(node, new_resource),
          extract_to: '/opt/nomad'
        )
      end

      def action_create
        archive_url = options[:archive_url] % {
          version: options[:version],
          basename: options[:archive_basename]
        }

        notifying_block do
          directory ::File.join(options[:extract_to], new_resource.version) do
            recursive true
          end

          zipfile options[:archive_basename] do
            path ::File.join(options[:extract_to], new_resource.version)
            source archive_url
            checksum options[:archive_checksum]
            not_if { ::File.exist?(nomad_program) }
          end

          link '/usr/local/bin/nomad' do
            to options[:extract_to] + '/' + new_resource.version + '/nomad'
          end
        end
      end

      def action_remove
        notifying_block do
          directory ::File.join(options[:extract_to], new_resource.version) do
            recursive true
            action :delete
          end

          link '/usr/local/bin/nomad' do
            action :delete
            only_if 'test -L /usr/local/bin/nomad'
          end
        end
      end

      def nomad_program
        ::File.join(options[:extract_to], new_resource.version, 'nomad')
      end

      def self.default_archive_url
        "https://releases.hashicorp.com/nomad/%{version}/%{basename}" # rubocop:disable Style/StringLiterals
      end

      def self.binary_basename(node, resource)
        case node['kernel']['machine']
        when 'x86_64', 'amd64' then ['nomad', resource.version, node['os'], 'amd64'].join('_')
        when 'i386' then ['nomad', resource.version, node['os'], '386'].join('_')
        else ['nomad', resource.version, node['os'], node['kernel']['machine']].join('_')
        end.concat('.zip')
      end

      def self.binary_checksum(node, resource)
        tag = node['kernel']['machine'] =~ /x86_64/ ? 'amd64' : node['kernel']['machine']
        case [node['os'], tag].join('-')
        when 'darwin-amd64'
          case resource.version
          when '0.4.1' then '5f2d52c73e992313e803fb29b6957ad1b754ed6e68bed5fa9fbe9b8e10a67aeb'
          end
        when 'linux-i386'
          case resource.version
          when '0.4.1' then 'fc5b750c9b895f2ddf6d4a6e313d0724f7d0c623ca44119b3cd7732f0b6415ae'
          end
        when 'linux-amd64'
          case resource.version
          when '0.4.1' then '0cdb5dd95c918c6237dddeafe2e9d2049558fea79ed43eacdfcd247d5b093d67'
          end
        when 'linux-arm'
          case resource.version
          when '0.4.1' then '6f74092e232702bf921e52ed1e2e7e76aeb24ae119802b024b865f81bccca29b'
          end
        when 'windows-i386'
          case resource.version
          when '0.4.1' then '16a6751efa0f6278ec34ec79b8ba2ee6fbf3dbd80b79e7fe67128a2d9beeb219'
          end
        when 'windows-amd64'
          case resource.version
          when '0.4.1' then '9940bf71b970df2c9e89ffb8307976a2c2e1d256e80da3767b36d3110594b969'
          end
        end
      end
    end
  end
end
