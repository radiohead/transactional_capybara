module Mysql2ClientMutex
  @@semaphore = Mutex.new

  def query_with_lock(*args)
    @@semaphore.synchronize { query_without_lock(*args) }
  end

  def self.prepended(base)
    base.class_eval do
      alias_method :query_without_lock, :query
      alias_method :query, :query_with_lock
    end
  end
end

module TransactionalCapybara
  module_function
  def use_mutexes
    Mysql2::Client.prepend(Mysql2ClientMutex) if defined?(Mysql2::Client) == 'constant'
  end
end
