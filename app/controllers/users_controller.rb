class UsersController < ApplicationController
  def index
    @users = User.all.order({ :username => :asc })

    render({ :template => "users/index.html" })
  end

  def new_registration_form

    render({ :template => "users/signupform.html.erb" })
  end

  def show
    the_username = params.fetch("the_username")
    @user = User.where({ :username => the_username }).at(0)

    render({ :template => "users/show.html.erb" })
  end

  def sign_out
    reset_session

    redirect_to("/", {:notice => "Signed out successfully."})
  end

  def sign_in
    render({ :template => "users/signinform.html.erb"})
  end

  def follow
    
  end


  def authenticate
  email = params.fetch("input_email")
  pw = params.fetch("input_password")

  user = User.where({:email=>email}).at(0)

  if user == nil
    redirect_to("/user_sign_in", {:alert=> "No one by that name here"})
  else
    if user.authenticate(pw)
      session.store(:user_id, user.id)
      redirect_to("/", {:notice =>  "Signed in successfully."} )
    else
      redirect_to("user_sign_in", {:alert=> "nice try"})
    end
  end

  end
  def create
    user = User.new

    user.username = params.fetch("input_username")
    user.email = params.fetch("input_email")
    user.private = params.fetch("input_private")
    user.password = params.fetch("input_password")
    user.password_confirmation = params.fetch("input_password_confirmation")

    save_status = user.save

    if save_status == true
      session.store(:user_id, user.id)
      redirect_to("/users/#{user.username}", {:notice => "Welcome, " + user.username + "!"})
    else 
      redirect_to("/user_sign_up", {:alert => user.errors.full_messages.to_sentence})
    end
  end

  def update
    the_id = params.fetch("the_user_id")
    user = User.where({ :id => the_id }).at(0)


    user.username = params.fetch("input_username")

    user.save
    
    redirect_to("/users/#{user.username}")
  end

  def destroy
    username = params.fetch("the_username")
    user = User.where({ :username => username }).at(0)

    user.destroy

    redirect_to("/users")
  end

end
