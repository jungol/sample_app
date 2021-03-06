require 'spec_helper'

describe "Authentication" do
  
  subject { page }
  
  describe "signin page" do
    before { visit signin_path }
    
    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
    it { should have_content('Forgot Password?') }
  end

  describe "signin" do
    
    context "with invalid information" do
      before { sign_in(User.new) }
      
      it { should have_title('Sign in') }
      it { should have_error_message('Invalid') }
    
      context "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_error_message('Invalid') }
      end
    end # "with invalid information"
    
    context "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }
      
      it { should have_title(user.name) }
      it { should have_link('Profile',     href: user_path(user))      }
      it { should have_link('Sign out',    href: signout_path)         }
      it { should have_link('Settings',    href: edit_user_path(user)) }
      it { should_not have_link('Sign in', href: signin_path)          }
      it { should have_link('Users',       href: users_path)           }
      
      context "followed by signout" do
        before { sign_out }
        
        it { should have_link('Sign in') }
        it { should_not have_link('Profile',     href: user_path(user)      ) }
        it { should_not have_link('Sign out',    href: signout_path         ) }
        it { should_not have_link('Settings',    href: edit_user_path(user) ) }
        it { should_not have_link('Users',       href: users_path           ) }     
      end
    end
  end

  describe "authorization" do
    
    context "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      
      context "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          valid_signin(user)
        end
        
        context "after signing in" do
         
          it "should render the desired protected page" do
            expect(page).to have_title('Edit user')
          end
          
          context "should render default (profile) page on subsequent signin" do
            before { sign_out }
            before { sign_in user }
            specify { expect(page).to have_title(user.name) }
          end
        end
      end
      
      context "in the Users controller" do
      
        context "visiting the edit page" do
          before { visit edit_user_path(user) }
          it {should have_title('Sign in') }
        end
        
        context "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end
        
        context "visiting the user index" do
          before { visit users_path }
          it { should have_title('Sign in') }
        end
        
        context "visiting the following page" do
          before { visit following_user_path(user) }
          it { should have_title('Sign in') }
        end
        
        context "visiting the followers pages" do
          before { visit followers_user_path(user) }
          it { should have_title('Sign in') }
        end
        
      end
      
      context "in the Microposts controller" do
        
        context "submitting to the create action" do
          before { post microposts_path }
          specify { expect(response).to redirect_to(signin_path) }
        end
        
        context "submitting to the destroy action" do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
      
      context "in the Relationships controller" do
        
        describe "submitting to the create action" do
          before { post relationships_path }
          specify { expect(response).to redirect_to(signin_path) }
        end
        
        describe "submitting to the destroy action" do
          before { delete relationship_path(1) }
          specify { expect(response).to redirect_to(signin_path) }
        end
        
      end
      
    end
    
    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user, no_capybara: true }
      
      describe "submitting a GET request to the Users#edit action" do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title('Edit user')) }
        specify { expect(response).to redirect_to(root_url) }
      end
      
      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end
    
    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }
      
      before { sign_in non_admin, no_capybara: true }
      
      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end   
      
      describe "visiting the signup page" do
        before { visit signup_path }
        specify { expect( redirect_to(root_path) ) }
      end
        
      describe "submitting a CREATE request to the Users#create action" do
        before { post users_path }
        specify { expect(redirect_to(root_path) ) }
      end
    
      describe "visiting the reset password page" do
        before { visit new_password_reset_path }
        specify { expect(redirect_to(root_path))}
      end

    end
    
    describe "as admin user" do
      let(:admin) {FactoryGirl.create(:admin) }
      before { sign_in admin, no_capybara: true }
      
      describe "submitting a DELETE request on him/herself to the Users#destroy action" do
        before { delete user_path(admin) }
        specify { expect(redirect_to(users_path) )}
        #this doesn't really test that the user hasn't been deleted. Need to learn rspec better
        
      end
    end
  end
end


