namespace :email do
  desc "Create Routes"
  task :creat_routes => :environment do
    data = Multimap.new
    data[:priority] = 1
    data[:description] = "All Forward"
    data[:expression] = "match_recipient('notice@charleschu.mailgun.org')"
    data[:action] = "forward('http://758f666d2d03.v2.localtunnel.com/email/recieve')"
    data[:action] = "forward('cxcumt87@gmail.com')"
    data[:action] = "stop()"
    RestClient.post "https://api:key-16qe6sz-8wtgabba2ei96pcb89823q65"\
    "@api.mailgun.net/v2/routes", data
  end
end
