require 'spec_helper_acceptance'

describe 'ansible class' do

  context 'default parameters' do

    let(:pp) do
      <<-EOS
        class { 'ansible': }
      EOS
    end

    # Run it twice and test for idempotency
    it_behaves_like 'an idempotent resource'

    describe package('ansible') do
      it { is_expected.to be_installed }
    end

    describe file('/etc/ansible/ansible.cfg') do
      it { is_expected.to be_file }
      its(:content) { should match /retry_files_save_path = ~\/\.ansible/ }
    end

    describe file('/usr/local/bin/ansible_inventory_cortex.py') do
      it { is_expected.to be_file }
      it { is_expected.to be_executable.by('owner') }
      it { is_expected.to be_executable.by('group') }
      it { is_expected.to be_executable.by('others') }
      its(:content) { should match /Ansible Inventory plugin for Cortex/ }
    end

    describe file('/etc/ansible/playbooks') do
     it { is_expected.to be_directory }
    end

  end
end
