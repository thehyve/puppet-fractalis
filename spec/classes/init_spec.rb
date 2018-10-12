require 'spec_helper'
describe 'fractalis' do
  on_supported_os.each do |os, facts|
    context "with default values for all parameters on #{os}" do
      let(:facts) { facts }
      let(:node) { 'test.example.com' }
      it { should contain_class('fractalis') }
    end
  end
end
