require 'spec_helper'

describe service('nomad') do
  it { is_expected.to be_running }
end

describe command('nomad agent-info') do
  its(:exit_status) { is_expected.to eq 0 }
end
