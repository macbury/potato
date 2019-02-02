# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include Wisper::Publisher
  self.abstract_class = true
end
