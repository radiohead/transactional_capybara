require 'transactional_capybara'

RSpec.configure do |config|
  TransactionalCapybara.share_connection
  TransactionalCapybara.use_mutexes

  config.after(:each, js: true) do
    TransactionalCapybara::AjaxHelpers.wait_for_ajax(page)
  end
end
