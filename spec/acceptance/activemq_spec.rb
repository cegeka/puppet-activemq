require 'spec_helper_acceptance'

describe 'activemq' do

  describe 'running puppet code' do
    it 'should work with no errors' do
      pp = <<-EOS
        include cegekarepos::cegeka
        Yum::Repo['cegeka-custom-noarch']
        class { 'activemq':
          version => '5.13.2-2.cgk.el7',
        }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file '/etc/activemq/activemq.xml' do
      it { is_expected.to be_file }
    end

  end
end
