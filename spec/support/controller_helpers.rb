# ControllerHelpers module holds common rspec testing methods
module ControllerHelpers
  def sign_in(user = double('user'))
    if user.nil?
      allow(request.env['warden']).to receive(:authenticate!)
        .and_throw(:warden, scope: :user)
      allow(controller).to receive(:current_user).and_return(nil)
    else
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(:current_user).and_return(user)
    end
  end
end

shared_examples 'requires sign in' do
  it 'redirects to the sign in page' do
    action
    expect(response).to redirect_to new_user_session_path
  end
end
