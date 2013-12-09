class HomeController < ApplicationController

  def index
    if is_logged_in?
       redirect_to login_user.default_organization.blank? ? no_organizations_path : personal_topics_inbox_path
    end
  end

  def about_us
  end

  def faq
  end

  def agreement
  end

end
