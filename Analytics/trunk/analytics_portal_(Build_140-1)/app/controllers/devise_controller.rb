class DeviseController < ActionController::Base
  skip_authorization_check

  def index
    respond_to do |format|
      format.html { render :layout => 'application' }
    end
  end

  def chgpasswd
    _notice_ = 'User password successfully changed.'
    _template_ = '/devise/nochgpasswd'
    if (params[:user][:password] == params[:user][:password_confirmation]) then
      begin
        params[:user].delete(:password) if params[:user][:password].blank?
        params[:user].delete(:password_confirmation) if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
        @user = User.find_all_by_reset_password_token(params[:user][:reset_password_token])
        if (@user.length > 0) then
          @user = @user[0]
          @user.update_attributes(params[:user])
          @user.reset_password_token=nil
          @user.save
          _template_ = '/devise/chgpasswd'
        else
          _notice_ = 'User password cannot be changed due to Authentication problem.  (Are you sure you are supposed to change this user\'s password?)  Please try again.'
        end
      rescue
        _notice_ = "User password has not been changed due to some kind of a system problem or #{$!}."
      end
    else
      _notice_ = 'User password cannot be changed due to Password and Password confirmation mismatch.  Please try again.'
    end
    respond_to do |format|
      format.html { render _template_, :layout => 'application' }
    end
  end

end
