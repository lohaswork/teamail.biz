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
        <p>假设你的 Email 地址 是 <strong>kk@kk.com</strong>，而你创建的公司或者团队名叫 <strong>kk</strong>，非常霸气的团队名字，有木有想起美国某党？（当然这里的名字均为虚构，如有雷同，纯属巧合）</p>
        <p>注册激活之后，登录后的默认界面就像是这样 ↓</p>
        <img src='/assets/guide-section-1.png' style='max-width:100%;'>
        <br>
        <br>
        <p>左侧边栏分为 <strong>个人空间</strong> 和 <strong>团队空间</strong>，团队空间下方有一些自动生成的标签；先不急细究它们的用途，跟随教程完成简单的四步。</p>
        <br>
        <h4 style='text-align:center;'>第 ① 步 <small>邀请同事一起加入</small></h4>
        <br>
        <p>点击上方导航栏右侧的 <strong>成员管理</strong></p>
        <img src='/assets/guide-section-2.png' style='max-width:45%;float:left;'>
        <img src='/assets/guide-section-3.png' style='max-width:45%;'>
        <br>
        <br>
        <p>如上图，输入团队成员的 <strong>Email 地址</strong>，然后点击 <strong>邀请</strong> 按钮，就完成了邀请。你的同事 <strong>sherry</strong> 会收到一封来自 teamail.biz 的邀请邮件。</p>
        <p>神奇的地方在于，即使 <strong>sherry</strong> 尚未激活系统账号，她也一样可以收到你从 teamail.biz 发送给她的邮件。并且，她 <strong>通过 Email</strong> 发出的回复也会自动<strong>收录</strong>到你所创建的团队空间。等她忙完手里的事再来慢慢摸索 teamail.biz 也不迟。</p>
        <br>
        <h4 style='text-align:center;'>第 ② 步 <small>通过 teamail.biz 发送第一封邮件</small></h4>
        <br>
        <p>通过 <strong>返回列表</strong> 回到我们的主界面，点击左侧边栏上部的 <strong>写邮件</strong> 按钮，浮现的新邮件窗口如下 ↓</p>
        <img src='/assets/guide-section-4.png' style='max-width:45%;float:left;'>
        <img src='/assets/guide-section-5.png' style='max-width:45%;'>
        <br>
        <br>
        <p>填入 <strong>标题、内容</strong>，选择 <strong>通知人</strong>，点击创建，即可通过 teamail.biz 成功发送你的第一封邮件。</p>
        <p>等一下，要是这时候想起来忘记通过 <strong>成员管理</strong> 页面添加某个人了怎么办？ 不着急，在 <strong>添加通知人输入框</strong> 中输入这个通知人的 Email 地址就好了，当然别忘了在通知人上 <strong>勾选新添加的地址</strong>。系统会发送这封邮件给该同学，并自动邀请TA加入你的团队。</p>
        <br>
        <img src='/assets/guide-section-6.png' style='max-width:100%;'>
        <br>
        <br>
        <p>邮件创建成功了，而且还被打上了 <strong>任务</strong> 这个标签。让我来说明一下，写邮件的 <strong>标题</strong> 时，只要在前面用 <strong>半角方括号 [] 括起来的字</strong> 都会被识别为 <strong>标签</strong> 用于分类。你可以用标签标识不同项目，也可以用它标明这封信是一项<strong>任务</strong>，还是一个<strong>讨论</strong>，亦或是一则<strong>通知</strong>或者<strong>分享</strong>。只有你想不到的，没有它做不到的。^_^ teamail.biz 支持加入多个标签，只要分别用 [] 括起来，并且和真正的标题空一格即可。想要发布一项属于  <strong>示例项目</strong> 的  <strong>任务</strong> ？，瞧就这么简单！</p>
        <br>
        <h4 style='text-align:center;'>第 ③ 步 <small>灵活运用标签来进行邮件管理和筛选</small></h4>
        <br>
        <p>接下来，我们来给新创建的邮件加上 <strong>“使用帮助”</strong> 这个新标签。</p>
        <p>勾选中第一封邮件前面的 <strong>选择框</strong>，点击列表上方的 <strong>标签按钮组</strong>，就会看到这样的界面 ↓</p>
        <img src='/assets/guide-section-7.png' style='max-width:45%;float:left;'>
        <img src='/assets/guide-section-8.png' style='max-width:45%;'>
        <br>
        <br>
        <p>很亲切有木有？跟一般的 Email 客户端的操作类似。输入 <strong>使用帮助</strong> 后点击 <strong>新建</strong>，标签就出现了。然后勾选中刚出现 <strong>使用帮助</strong> 标签，点击 <strong>应用</strong> 按钮，搞定！</p>
        <br>
        <p>通过 <strong>团队空间</strong> ，你可以查看团队整体的项目状况。对，没有发送给你的邮件照样可以看到！这对需要及时把握项目动向的Leader和需要快速熟悉项目状况的新人尤其有用。那如果邮件很多，如何快速筛选你想要的邮件呢？看这边，看这边，只要一步就好 ↓</p>
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
        <p>和写新邮件时的界面一样，我想聪明的你已经不需要我来指导了。<br>当然别忘了，邮件是可以上传文件的，注意到编辑框右上角的 <strong>上传文件</strong> 没？</p>
        <br>
        <p>teamail.biz 的所有操作都会以 <strong>邮件的形式</strong> 发送给 <strong>你选择的通知人</strong>，让我们来看看 <strong>sherry</strong> 收到的邮件吧。</p>
        <img src='/assets/guide-section-11.png' style='max-width:100%;'>
        <br>
        <br>
        <p>当你 <strong>处理完毕</strong> 某封邮件（完成了邮件指派的任务或是已经知晓邮件传达的内容），点击上方的 <strong>归档</strong> 按钮，那么这个邮件序列将不会再出现在你的 <strong>收件箱</strong> 中。养成随时清空收件箱的习惯，是你通往 <strong>高效工作</strong> 的第一步！</p>
        <p>当然，你可以在 <strong>个人空间下的所有邮件</strong> 以及 <strong>团队空间</strong> 中找到已归档的邮件。</p>
      </div>
    "
  end
end
