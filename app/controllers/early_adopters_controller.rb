# encoding: utf-8
class EarlyAdoptersController < ApplicationController
  def index
    if authenticated?
      redirect_to non_organizations? ? non_organ_path : topics_path
    end
  end

  def create
    email = params[:email]
    EarlyAdopter.create_early_adopter(email)
    render :json => {
                    :update => {
                                  'early-adopter-form' => render_to_string(:partial => 'apply_form',
                                                                          :layout => false)
                                },
                    :modal => render_to_string(:partial => 'create_success',
                                                :layout => false)
                    }
  end
end
