# encoding: utf-8
class EarlyAdoptersController < ApplicationController
  def index
    if authenticated?
      redirect_to welcome_path
    else
      render :layout => false
    end
  end

  def create
    email = params[:email]
    EarlyAdopter.create!(:email => email)
    render :json => {
                    :update => {
                                  'early-adopter-from' => render_to_string(:partial => 'apply_form',
                                                                          :layout => false)
                                },
                    :modal => render_to_string(:partial => 'create_success',
                                                :layout => false)
                    }
  end
end