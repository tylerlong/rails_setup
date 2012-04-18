require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do
    let(:admin) { FactoryGirl.create(:admin) }
    before do
      sign_in admin
      visit users_path
    end
    it { should have_selector('title', text: 'All users') }
  end

  describe "Signup page" do
    before { visit signup_path }
    it { should have_selector('h1', text: 'Sign up') }
    it { should have_selector('title', text: 'Sign up') }
  end

  describe "Profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit user_path(user)
    end
    it { should have_selector('h1', text: user.name) }
    it { should have_selector('title', text: user.name) }
  end

  describe "Signup" do
    before { visit signup_path }
    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button "Create my account" }.not_to change(User, :count)
      end
      describe "error messages" do
        before { click_button "Create my account" }
        it { should have_selector('title', text: "Sign up") }
        it { should have_selector('div', text: "The form contains 6 errors") }
        it { should have_selector('li', text: "* Email can't be blank") }
      end
    end
    describe "with valid information" do
      it "should create a user" do
        expect { sign_up }.to change(User, :count).by(1)
      end
      describe "after saving the user" do
        before { sign_up }
        let(:user) { User.find_by_email('tylerlong@example.com') }
        it { should have_selector('title', text: user.name) }
        it { should have_flash_message(:success, 'Welcome') }
        it { should have_link('Sign out') }
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_selector('h1',    text: "Update your profile") }
      it { should have_selector('title', text: "Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end
    describe "with invalid information" do
      before { click_button "Save changes" }
      it { should have_content('error') }
    end
    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end
      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', :href => signout_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end
  end

  describe "destroy" do
    let(:user) { FactoryGirl.create(:user) }
    let(:admin) {FactoryGirl.create(:admin) }
    before { sign_in admin }

    describe "at first" do
      it "should exist" do
        User.find_by_id(user.id).should_not be_nil
      end
    end
    describe "delete the user" do
      before { delete user_path(user) }
      it "user disappear from db" do
        User.find_by_id(user.id).should be_nil
      end
    end
    describe "admin try to delete himself" do
      before { delete user_path(admin) }
      it "should fail" do
        User.find_by_id(admin.id).should_not be_nil
      end
    end
  end

end