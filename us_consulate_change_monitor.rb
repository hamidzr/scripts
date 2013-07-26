require 'mail'
require 'nokogiri'
require 'open-uri'
require 'sqlite3'

# def variables
@telegram_api = 'secret'
@tg_receiver = '@secret'
@check_interval = 5 #seconds
@use_mail = false
@use_tg = true

# Open a database
@db = SQLite3::Database.new "us_consulate.db"
if @db.execute("SELECT * FROM sqlite_master WHERE name ='changes' and type='table'").length == 0
	@db.execute <<-SQL
	  create table changes (
	    name varchar(100),
	    type varchar(30),
	    body text,
	    created_at varchar(100)
	  );
	SQL
end

# Execute inserts with parameter markers
# @db.execute("INSERT INTO changes (name, body)
#             VALUES (?, ?)", ["Jane", "me@janedoe.com", "A", "http://blog.janedoe.com"])

# Find a few rows
# @db.execute( "select * from students" ) do |row|
#   p row
# end


def scrape
    results = []
      url = 'https://ais.usvisa-info.com/en-ir'
      doc = Nokogiri::HTML(open(url))
      # doc.css('.forumtitle a').length

      student_dates = []
      doc.css('.ten li:nth-child(2)').each do |it|
        student_dates << it.text.strip
      end

      visitor_dates = []
      doc.css('.ten li:nth-child(3)').each do |it|
        visitor_dates << it.text.strip
      end

      names = []
      doc.css('.ten h4').each do |it|
        names << it.text.strip.gsub(/\n/,' ')
      end

      # puts names.inspect

      tedad = names.length
      results_sub = []
      tedad.times do |i|
        results_sub <<  {name: names[i], type: 'Student', date: student_dates[i]}
        results_sub << 	{name: names[i], type: 'Visitor', date: visitor_dates[i]}
      end

      results.push(*results_sub)

      return results
end

def notify(diff)

	puts "New changes! #{Time.now}"

	# visitors_diff = diff.reject{|x| type.include? x[:type]}
	# students_diff = diff.reject{|x| type.include? x[:type]}
	baraye = diff.map{ |x| x[:type]+'s'}.uniq

	msg = ''
	msg += "\xF0\x9F\x93\xA2  <b>#{baraye.join(', ')}</b>:             \n"
	diff.each do |d|
		msg += "\n<b>#{d[:name]}</b> <i>#{d[:type]}s</i> : #{d[:date]}\n"
	end
	msg += "\n"+'<a href="https://ais.usvisa-info.com/en-ir">Reserve!</a>'+"         \xF0\x9F\x91\x89 @UniDB"

	url = URI::encode("https://api.telegram.org/bot#{@telegram_api}/sendMessage?chat_id=#{@tg_receiver}&disable_notification=false&text=#{msg}&parse_mode=html")
	open(url)

	diff.each do |d|
		@db.execute("INSERT INTO changes (name, type, body, created_at) VALUES (?, ?, ?, ?)", [d[:name], d[:type], d[:date], "#{Time.now}"])
	end
	# msg = <<END_OF_MESSAGE
	# salam barobaks
	# hi che khabar
	# END_OF_MESSAGE

	if @use_mail
		#configure and deliver email
		options = { :address              => "smtp.gmail.com",
		            :port                 => 587,
		            # :domain               => 'your.host.name',
		            :user_name            => 'secret',
		            :password             => 'secret',
		            :authentication       => 'plain',
		            :enable_starttls_auto => true  }

		Mail.defaults do
		  delivery_method :smtp, options
		end

		Mail.deliver do
		       to 'secret'
		     from 'secret'
		  subject 'US Sefarat Change Detected'
		     body msg
		end
	end

end

old_results = []
while true
	new_results = scrape

	diff = []
	if old_results.length == 6
		new_results.each_with_index do |nr_hash, indx|
			diff << nr_hash if nr_hash[:date] != old_results[indx][:date]
		end
	else
		diff = new_results
	end

	# dates = old_results.map{|x| x[:date]}
	# puts new_results.inspect
	puts diff
	# =  new_results.reject{|x| dates.include? x[:date]}
	notify(diff) if diff.length > 0
	sleep @check_interval
	old_results = new_results
end


# # Find a few rows
# @db.execute( "select * from changes" ) do |row|
#   p row
# end
