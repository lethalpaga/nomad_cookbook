default['nomad']['version'] = '0.5.6'

default['nomad']['service_name'] = 'nomad'
default['nomad']['service_user'] = 'nomad'
default['nomad']['service_group'] = 'nomad'

default['nomad']['mode'] = 'client' # client or server

default['nomad']['config']['path'] = '/etc/nomad/nomad.json'
default['nomad']['config']['data_dir'] = nomad_data_path
