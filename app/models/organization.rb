# encoding: utf-8
class Organization < ActiveRecord::Base
  attr_accessible :name

  has_many :organization_memberships
  has_many :users, lambda { uniq }, :through => :organization_memberships
  has_many :topics
  has_many :tags
  # Cancel validation of uniqueness of name
  validates :name, presence: { :message => "组织名不能为空" } # :uniqueness => { :case_sensitive => false, :message => "组织名已使用" }

  scope :for_user, lambda { |user| joins(:users).where("user_id = ?", user.id).readonly(false) }

  def membership(user)
    self.organization_memberships.find_by_user_id(user.id)
  end

  def add_tag(tag_name)
    tag = Tag.new(:name => tag_name, :organization_id => self.id)
    raise ValidationError.new(tag.errors.messages.values) if !tag.valid?
    tag.save!
    self.save!
    self
  end

  def delete_user(user_id)
    user = User.find(user_id)
    self.users.delete(user)
    user.default_organization_id = user.organizations.first if user.default_organization_id == self.id
    user.save!
    self
  end

  def add_member_by_email(email)
    unless user = User.find_by_email(email)
      user = User.new(:email => email, :password => User.generate_init_password)
      raise ValidationError.new(user.errors.messages.values) if !user.valid?
      user.generate_reset_token
    end
    user.organizations << self
    user.default_organization_id = self.id if user.default_organization.blank?
    user.save!
    self
  end

  def has_member?(email)
    user = User.find_by_email(email)
    self.users.include? user
  end

  def setup_seed_data(user)
    # Create default tags
    tags = []
    ["示例项目", "任务"].each_with_index do |name, index|
      tag = Tag.create(:name => name, :organization_id => self.id, :color => (index + 1).to_s)
      tags << tag.id
    end
    # Create manual topic
    title = "如何使用teamail进行项目管理"
    email_title = "[示例项目][任务]" + " " + title
    content = manual_content
    topic = Topic.create_topic(title, email_title, content, emails=[], self, user)
    topic.add_tags(tags)
  end

  private
  def manual_content
    %"
      <div>
        <h4 style='color: #389DD8;text-align:center;'>简单入门 <br><small>跟随这个教程，玩转 teamail.biz，只要 3 分钟。</small></h4>
        <p>假设你的 email 地址 是 <strong>kk@kk.com</strong>，而你创建的公司或者组织名叫 <strong>kk</strong>，非常霸气的组织名，像是意大利某党的名字。（当然这里的名字均为虚构，如有雷同，纯属巧合）</p>
        <p>注册激活之后，登录后的默认界面就像是这样 ↓</p>
        <img src='/assets/guide-section-1.png' style='max-width:100%;'>
        <br>
        <br>
        <p>左侧分为了 <strong>个人空间</strong> 和 <strong>团队空间</strong>，团队空间下方有一些自动生成的标签；先不急细究它们的用途，跟随教程完成简单的四步。</p>
        <br>
        <h4 style='text-align:center;'>第 ① 步 <small>邀请同事一起加入</small></h4>
        <br>
        <p>点击上方导航栏右侧的 <strong>成员管理</strong></p>
        <img src='/assets/guide-section-2.png' style='max-width:50%;float:left;'>
        <img src='/assets/guide-section-3.png' style='max-width:50%;'>
        <br>
        <br>
        <p>如上图，输入同事的 <strong>email 地址</strong>，然后点击 <strong>邀请</strong> 按钮，就完成了邀请环节。你的同事 <strong>sherry</strong> 会收到一封来自「teamail.biz」的邀请邮件。</p>
        <p>神奇的地方在于，即使 <strong>sherry</strong> 没有点击激活邮件上的链接来激活 teamail 账号，她也一样可以收到你在 teamail 的通知邮件，同样，她 <strong>通过 email</strong> 发出的回复也会<strong>收录</strong>到你的组织 <strong>kk</strong> 中。</p>
        <br>
        <h4 style='text-align:center;'>第 ② 步 <small>通过 teamail 发送第一封邮件</small></h4>
        <br>
        <p>点击 <strong>返回列表</strong> 回到我们的主界面，点击左侧边栏上部的 <strong>写邮件</strong>按钮，浮现的新邮件窗口如下 ↓</p>
        <img src='/assets/guide-section-4.png' style='max-width:45%;float:left;'>
        <img src='/assets/guide-section-5.png' style='max-width:45%;'>
        <br>
        <br>
        <p>填入 <strong>标题、内容</strong>，选择 <strong>通知人</strong>，点击创建，即可成功发送你的第一封邮件。</p>
        <p>等一下，要是这时候想起来忘记添加某个通知人了，怎么办？ 不着急，在 <strong>添加通知人输入框</strong> 中输入这个通知人的 email 地址就好了，当然别忘了在通知人上 <strong>勾选新添加的地址</strong>。</p>
        <br>
        <img src='/assets/guide-section-6.png' style='max-width:100%;'>
        <br>
        <br>
        <p>邮件创建成功了，而且还被打上了 <strong>任务</strong> 这个标签。让我来说明一下，写邮件时的 <strong>标题</strong>，只要在前面用 <strong>英文的方括号 [] 括起来的字</strong> 都会被识别为 <strong>标签</strong>，你可以在写邮件的时候同时加入多个标签，只要分别用 [] 括起来，并且和真正的标题空一格即可。小技巧哦！</p>
        <br>
        <h4 style='text-align:center;'>第 ③ 步 <small>灵活运用标签来进行邮件管理和筛选</small></h4>
        <br>
        <p>接下来，我们来给新创建的邮件加上 <strong>“使用帮助”</strong> 这个新标签。</p>
        <p>勾选中第一封邮件前面的 <strong>选择框</strong>，点击列表上方的 <strong>标签按钮组</strong>，就会看到这样的界面 ↓</p>
        <img src='/assets/guide-section-7.png' style='max-width:45%;float:left;'>
        <img src='/assets/guide-section-8.png' style='max-width:45%;'>
        <br>
        <br>
        <p>很亲切有木有？跟一般的 email 客户端的操作类似。输入 <strong>使用帮助</strong> 后点击 <strong>新建</strong>，标签就出现了。然后勾选中刚出现 <strong>使用帮助</strong> 标签，点击 <strong>应用</strong> 按钮，搞定！</p>
        <br>
        <p>那如果邮件很多，如何快速筛选你想要的邮件呢？看这边，看这边，只要一步就好 ↓</p>
        <img src='/assets/guide-section-9.png' style='max-width:100%;'>
        <br>
        <br>
        <p>点击左侧边栏的 <strong>标签</strong> 进行 <strong>筛选</strong>，可以多选哦！多选时会显示同时带有选中的这几个标签的邮件。</p>
        <p>标签还有很多妙用，留待你慢慢发现。</p>
        <br>
        <h4 style='text-align:center;'>第 ④ 步 <small>回复邮件和归档</small></h4>
        <br>
        <p>点击 <strong>邮件的标题</strong>，查看邮件的详细内容。</p>
        <img src='/assets/guide-section-10.png' style='max-width:100%;'>
        <br>
        <br>
        <p>和写新邮件时的界面一样，我想聪明的你已经不需要我来指导了。<br>当然别忘了，邮件是可以上传文件的，注意到编辑框右上角的 <strong>上传文件</strong> 了嘛？</p>
        <br>
        <p>teamail 的所有操作都会以 <strong>邮件的形式</strong> 发送给你 <strong>选择的通知人</strong>，让我们来看看 <strong>sherry</strong> 收到的邮件吧。</p>
        <img src='/assets/guide-section-11.png' style='max-width:100%;'>
        <br>
        <br>
        <p>当你不在 <strong>需要</strong> 这封邮件的时候，点击上方的 <strong>归档</strong> 按钮，那么这封邮件就不会再出现在你的 <strong>个人空间下的收件箱</strong> 中了。</p>
        <p>当然，你还可以在 <strong>个人空间下的所有邮件、团队空间</strong> 中找到它。</p>
      </div>
    "
  end
end
