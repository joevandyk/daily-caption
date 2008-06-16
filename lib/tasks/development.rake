require 'config/environment'

%w[development production staging].each do |env|
  desc "Runs the following task in the #{env} environment" 
  task env do
    RAILS_ENV = ENV['RAILS_ENV'] = env
  end
end

task :testing do
    RAILS_ENV = ENV['RAILS_ENV'] = 'test'
end

task :dev do
    Rake::Task["development"].invoke
end

task :prod do
    Rake::Task["production"].invoke
end


namespace(:db) do
  task :fill do
    num_users  = 10_0
    num_photos = 3_0
    flickr = Flickr.new
    photos = flickr.photos
    num_photos.downto(1) do |i|
      display_percent_done num_photos - i, num_photos, "creating photos"
      p = Photo.create! :flickr_id => photos[i].id, :captioned_at => i.hours.ago, :ended_captioning_at => (i + 1).hours.ago, :state => "captioning"
      p.process_flickr_photo
    end

    num_users.times do |i|
      display_percent_done i, num_users, "creating users, captions, and votes"
      username = Faker::Internet.user_name
      u = User.create! :site_id => 1, :username => username, :profile_url => "http://facebook.com/#{username}", :profile_image_url => "http://facebook.com/profile/#{username}.jpg"
      2.times { Caption.connection.execute "insert into captions (photo_id, user_id, caption, created_at) values ((select id from photos order by random() limit 1), #{u.id}, '#{Faker::Lorem.sentence(5)}', now())" }
      5.times { Vote.connection.execute "insert into votes (caption_id, user_id, created_at) values((select id from captions order by random() limit 1), #{u.id}, now());" }
      Comment.connection.execute "insert into comments (caption_id, comment, user_id, created_at) values ((select id from captions order by random() limit 1), '#{ Faker::Lorem.sentences(3).join }', #{u.id}, now())"
    end
    Photo.update_all "state = 'captioned'"
    p = Photo.create! :flickr_id => photos.last.id, :captioned_at => Time.now, :ended_captioning_at => 1.hour.from_now
    p.update_attribute :state, 'captioning'
    p.process_flickr_photo
  end
end

def display_percent_done current, total, text
  if current != 0 and total >= 100 and current % (total / 100) == 0
    puts "finished #{ 100 * current / total }% of #{text}"
  end
end
