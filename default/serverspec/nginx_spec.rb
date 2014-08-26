# encoding: utf-8
#
# Copyright 2014, Deutsche Telekom AG
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'spec_helper'


RSpec.configure do |c|
  c.filter_run_excluding skipOn: backend(Serverspec::Commands::Base).check_os[:family]
end

RSpec::Matchers.define :match_key_value do |key, value|
  match do |actual|
    actual =~ /^\s*?#{key}\s*?=\s*?#{value}/
  end
end

# determine all required paths
nginx_path      = '/etc/nginx'
nginx_conf      = File.join( nginx_path, 'nginx.conf' )
nginx_confd     = File.join( nginx_path, 'conf.d' )
nginx_enabled   = File.join( nginx_path, 'sites-enabled')
nginx_hardening = File.join( nginx_confd, '90.hardening.conf' )

# check for files
describe 'nginx default files' do
  describe file(File.join(nginx_confd, 'default.conf')) do
    it { should_not be_file }
  end

  describe file(File.join(nginx_enabled, 'default')) do
    it { should_not be_file }
  end
end

# check configuration parameters
describe 'check nginx config file' do

  describe file(nginx_conf) do
    its(:content) { should match(/^\s*server_tokens off;$/) }
  end

  describe file(nginx_conf) do
    its(:content) { should match(/^\s*client_body_buffer_size 1k;$/) }
  end

  describe file(nginx_conf) do
    its(:content) { should match(/^\s*client_max_body_size 1k;$/) }
  end

  describe file(nginx_conf) do
    its(:content) { should match(/^\s*keepalive_timeout\s+5 5;$/) }
  end

end

# check additional configuration parameters
describe 'check additional nginx config' do

  describe file(nginx_hardening) do
    its(:content) { should match(/^\s*more_clear_headers 'Server';$/) }
  end

  describe file(nginx_hardening) do
    its(:content) { should match(/^\s*more_clear_headers 'X-Powered-By';$/) }
  end

  describe file(nginx_hardening) do
    its(:content) { should match(/^\s*client_header_buffer_size 1k;$/) }
  end

  describe file(nginx_hardening) do
    its(:content) { should match(/^\s*large_client_header_buffers 2 1k;$/) }
  end

  describe file(nginx_hardening) do
    its(:content) { should match(/^\s*client_body_timeout 10;$/) }
  end

  describe file(nginx_hardening) do
    its(:content) { should match(/^\s*client_header_timeout 10;$/) }
  end

  describe file(nginx_hardening) do
    its(:content) { should match(/^\s*send_timeout 10;$/) }
  end

  describe file(nginx_hardening) do
    its(:content) { should match(/^\s*limit_conn_zone \$binary_remote_addr zone=default:10m;$/) }
  end

  describe file(nginx_hardening) do
    its(:content) { should match(/^\s*limit_conn default 5;$/) }
  end

  describe file(nginx_hardening) do
    its(:content) { should match(/^\s*add_header X-Frame-Options SAMEORIGIN;$/) }
  end

  describe file(nginx_hardening) do
    its(:content) { should match(/^\s*add_header X-Content-Type-Options nosniff;$/) }
  end

  describe file(nginx_hardening) do
    its(:content) { should match(/^\s*add_header X-XSS-Protection "1; mode=block";$/) }
  end

end