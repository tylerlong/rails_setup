def sign_up
  fill_in "Name",         with: "Tyler Long"
  fill_in "Email",        with: "tylerlong@example.com"
  fill_in "Password",     with: "foobar"
  fill_in "Confirm Password", with: "foobar"
  click_button "sign_up"
end

def sign_in(user)
  visit signin_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "sign_in"
  cookies[:remember_token] = user.remember_token
end