class BaseService
  include Dry::Transaction
  include Wisper::Publisher

  def self.call(*args, &block)
    new.call(*args, &block)
  end
end