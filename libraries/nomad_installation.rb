require 'poise'

require_relative 'nomad_installation_binary'

module NomadCookbook
  module Resource
    # A `nomad_installation` resource for managing the installation of
    # Nomad.
    # @action create
    # @action remove
    class NomadInstallation < Chef::Resource
      include Poise(inversion: true)
      provides(:nomad_installation)
      actions(:create, :remove)
      default_action(:create)

      # @!attribute version
      # The version of Nomad to install.
      # @return [String]
      attribute(:version, kind_of: String, name_attribute: true)

      def nomad_program
        @program ||= provider_for_action(:nomad_program).nomad_program
      end
    end
  end
end
