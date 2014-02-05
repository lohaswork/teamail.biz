# encoding: utf-8
class OauthAccessToken < ActiveRecord::Base
  belongs_to :user
end
