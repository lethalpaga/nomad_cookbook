#
# Cookbook: nomad
# License: Apache 2.0
#

module NomadCookbook
  module Helpers
    include Chef::Mixin::ShellOut

    extend self

    def arch_64?
      node['kernel']['machine'] =~ /x86_64/ ? true : false
    end

    def windows?
      node['os'].eql?('windows') ? true : false
    end

    def program_files
      ENV['PROGRAMFILES']
    end

    def data_path
      windows? ? File.join(program_files, 'nomad', 'data') : File.join('/var/lib', 'nomad')
    end

    def binary_checksum(item)
      node['nomad']['checksums'].fetch(binary_filename(item))
    end

    def binary_filename(item)
      case item
      when 'binary'
        arch = arch_64? ? 'amd64' : '386'
        ['nomad', version, node['os'], arch].join('_')
      end
    end
  end
end

Chef::Node.send(:include, NomadCookbook::Helpers)
