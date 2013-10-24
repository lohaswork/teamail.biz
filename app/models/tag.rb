# encoding: utf-8
class Tag < ActiveRecord::Base
  attr_accessible :color, :name

  belongs_to :organization
  has_many :taggings
  has_many :topics, -> { uniq }, :through => :taggings
  VALID_TAGNAME_TEGEX = /\A(?![-_—])(?!.*?[-_—]$)[a-zA-Z0-9\-—_\u4e00-\u9fa5]+\z/
  validates :name, :presence => { :message => "标签名不能为空" },
                   :format => { :with => VALID_TAGNAME_TEGEX, :message=>"名称不合法，标签名只能包含汉字、字母、数字、下划线'_'和连接号'-'，且不能以下划线和连接号开头或结尾", :allow_blank => true },
                   :uniqueness => { :case_sensitive => true, :message => "标签名已使用" }

end
