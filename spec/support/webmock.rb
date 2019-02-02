# frozen_string_literal: true
require 'webmock/rspec'

WebMock.enable!
WebMock.disable_net_connect!(allow_localhost: true)