RSpec::Matchers.define :have_flash_message do |category, message|
  match do |page|
    if message.nil?
      page.should have_selector("div.alert.alert-#{category}")
    else
      page.should have_selector("div.alert.alert-#{category}", text: message)
    end
  end
end