require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }
    it { should have_selector('h1',    text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }
  end

  describe "signin" do
    before { visit signin_path }
    describe "with invalid information" do
      before { click_button "Sign in" }
      it { should have_selector('title', text: 'Sign in') }
      it { should have_flash_message(:error, 'Invalid') }
      describe "after visiting another page" do
        before { click_link "Rails Setup" }
        it { should_not have_flash_message(:error) }
      end
    end
    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }
      it { should have_selector('title', text: user.name) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should_not have_link('Sign out', href: signout_path) }
        it { should have_link('Sign in', href: signin_path) }
      end
    end
  end

  describe "authorization" do
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          sign_in user
        end
        describe "after signing in" do
          it "should render the desired protected page" do
            page.should have_selector('title', text: 'Edit user')
          end
          describe "when signing in again" do
            before do
              click_link "Sign out"
              sign_in user
            end
            it "should render user profile page" do
              page.should have_selector('title', text: user.name)
            end
          end
        end
      end
      describe "visiting the user edit" do
        before { visit edit_user_path(user) }
        it { should have_selector('title', text: 'Sign in') }
      end
      describe "visiting the user index" do
        before { visit users_path }
        it { should have_selector('title', text: 'Sign in') }
      end
      describe "updating an user profile" do
        before { put user_path(user) }
        specify { response.should redirect_to(signin_path) }
      end
    end
    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }
      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: 'Edit user') }
      end
      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(back_path) }
      end
    end
    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(back_path) }
      end
    end
    describe "as signed-in user" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }
      describe "try to access the signup_path" do
        before { visit signup_path }
        it { should have_selector('title', text: 'Back') }
      end
      describe "submitting a POST request to the Users#create action" do
        before { post users_path }
        specify { response.should redirect_to(back_path) }
      end
    end
  end

end