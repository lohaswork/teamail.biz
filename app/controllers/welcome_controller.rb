# encoding: utf-8
class WelcomeController < ApplicationController
  def index
    if is_logged_in?
       redirect_to login_user.default_organization.blank? ? no_organizations_path : personal_topics_path
    end
  end

  def add_early_adotpers
    EarlyAdopter.create_early_adopter(params[:email])
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
