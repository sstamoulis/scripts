#!/usr/bin/env ruby
# coding: utf-8
# Copyright muflax <mail@muflax.com>, 2012
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

require "cri"
require "mechanize"
require "nokogiri"
require "zlib"

command = Cri::Command.define do
  name        'google_web_history'
  usage       'google_web_history [options] output.xml.gz'
  summary     'downloads google web history'

  flag :h, :help,  'show help' do |value, cmd|
    puts cmd.help
    exit 0
  end

  required :u, :user,     'user'
  required :p, :password, 'password'

  run do |opts, args, cmd|
    output = args.shift

    if output.nil?
      puts "output file required"
      exit 1
    end

    if opts[:user].nil? or opts[:password].nil?
      puts "need login data"
      exit 1
    end

    puts "grabbing web history..."
    
    # log into google
    agent = Mechanize.new
    agent.user_agent_alias = 'Linux Mozilla'

    page = agent.get "https://www.google.com/accounts/Login?hl=en"
    login_form = page.forms.first
    login_form['Email'] = opts[:user]
    login_form['Passwd'] = opts[:password]
    login_form['remember'] = "1"
    page = agent.submit login_form

    # grab history
    date = nil
    history = {}

    def history_url date=nil, num=1000
      "https://www.google.com/history/lookup?q=&output=rss&num=#{num}" +
        if date.nil?
          "&start=1"
        else
          "&yr=#{date.year}&month=#{date.month}&day=#{date.day}"
        end
    end
    
    catch :done do
      while true
        # grab page
        page = agent.get history_url(date)
        
        # extract rss file (treat it as XML 'cause google uses custom tags)
        doc = Nokogiri::XML.parse(page.body)

        items = doc.xpath("//item")
        
        # stop when no more items are returned
        throw :done if items.empty?

        # merge with existing data
        items.each do |item|
          guid = item.xpath(".//guid").first.content
          history[guid] = item unless history.include? guid
        end

        # get new date, making sure not to repeat ourselves
        new_date = DateTime.parse(items.last.xpath("./pubDate").first.content)
        new_date -= 1 if new_date == date
        date = new_date
          
        puts "#{history.size} items, continuing on #{date}..."
      end
    end

    # sort items
    items = history.values.sort_by{|item| item.xpath(".//pubDate").first.content}
    
    # save file
    puts "saving (compressed) history..."
    Zlib::GzipWriter.open(output) do |f|
      # pseudo-header
      f.write <<EOL
<rss version="2.0">
<channel>
<title>Google Web History</title>
<link>http://www.google.com/history/</link>
<description>Google - Search History RSS feed</description>
EOL
      
      items.each do |item|
        item.write_to(f, :indent => 2, :encoding => "UTF-8")
      end

      #pseudo-footer
      f.write <<EOL
</channel>
</rss>
EOL
    end
  end
end

command.run(ARGV)
