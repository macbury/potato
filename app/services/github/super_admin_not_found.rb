module Github
  class SuperAdminNotFound < StandardError
    def initialize
      super('Super admin is not found')
    end
  end
end
