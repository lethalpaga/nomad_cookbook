#
# Cookbook Name:: nomad
# Recipe:: default
#

poise_service_user node['nomad']['service_user'] do
  group node['nomad']['service_group']
  not_if { node['nomad']['service_user'] == 'root' }
end

install = nomad_installation node['nomad']['version'] do
  if node['nomad']['installation']
    node['nomad']['installation'].each_pair { |k, v| r.send(k, v) }
  end
end

nomad_config node['nomad']['config']['path'] do |r|
  owner node['nomad']['service_user']
  group node['nomad']['service_group']

  if node['nomad']['config']
    node['nomad']['config'].each_pair { |k, v| r.send(k, v) }
  end
  notifies :reload, "nomad_service[#{node['nomad']['service_name']}]", :delayed
end

nomad_service node['nomad']['service_name'] do |r|
  user node['nomad']['service_user']
  group node['nomad']['service_group']
  config_path node['nomad']['config']['path']
  program install.nomad_program

  if node['nomad']['service']
    node['nomad']['service'].each_pair { |k, v| r.send(k, v) }
  end
  action [:enable, :start]
end
