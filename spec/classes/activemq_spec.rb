#!/usr/bin/env rspec

require 'spec_helper'

describe 'activemq' do
  let(:params) { { :version => '5.10.0-1.cgk.el6' } }
  it { should contain_class 'activemq' }
end
