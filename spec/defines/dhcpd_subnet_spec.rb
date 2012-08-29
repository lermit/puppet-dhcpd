require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'dhcpd::subnet', :type => :define do

  let(:title) { 'dhcpd::subnet' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :arch => 'i386' , :operatingsystem => 'Debian' } }
  let(:params) { {
      :name => 'www.example42.com',
      :ip   => '10.42.42.42',
  } }

  describe 'Test dhcpd::subnet without options' do
    it 'should create a dhcp subnet file' do
      should contain_concat('/etc/dhcp/subnet-10.42.42.42.conf')
    end
    it 'should add include into dhcp.conf file' do
      should contain_concat__fragment('dhcpd-include-sudnet-10.42.42.42').with_target('/etc/dhcp/dhcpd.conf')
    end
    it 'should create a dhcp subnet file' do
      should contain_concat('/etc/dhcp/subnet-10.42.42.42.conf')
    end
    it 'should create a dhcp subnet header file' do
      should contain_concat__fragment('dhcpd-subnet-10.42.42.42-header').with_target('/etc/dhcp/subnet-10.42.42.42.conf')
      should contain_concat__fragment('dhcpd-subnet-10.42.42.42-header').with_order("01")
    end
    it 'should create a dhcp subnet footer file' do
      should contain_concat__fragment('dhcpd-subnet-10.42.42.42-footer').with_target('/etc/dhcp/subnet-10.42.42.42.conf')
      should contain_concat__fragment('dhcpd-subnet-10.42.42.42-footer').with_order(99)
    end
  end

  describe 'Test dhcpd::subnet decommissioning - absent' do
    let(:params) { {
      :name   => 'www.example42.com',
      :ip     => '10.42.42.42',
      :absent => true,
    } }
    it { should contain_file('subnet-www.example42.com').with_ensure('absent') }
    it { should_not contain_concat__fragment('dhcpd-include-sudnet-10.42.42.42') }
  end

  describe 'Test dhcpd::sudnet customizations - template' do
    let(:params) { {
      :name     => 'www.example42.com',
      :ip       => '10.42.42.42',
      :template => 'dhcpd/spec.erb',
    } }

    
    it 'should generate a valid template' do
      content = catalogue.resource('concat::fragment', 'dhcpd-subnet-10.42.42.42-header').send(:parameters)[:content]
      content.should match "fqdn: rspec.example42.com"
    end
  end
    

end

