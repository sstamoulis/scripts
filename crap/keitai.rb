#!/usr/bin/env ruby
# coding: utf-8
# Copyright muflax <mail@muflax.com>, 2011
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

require "open-uri"

url = "http://ip.tosp.co.jp/BK/TosBK100.asp?I=hidamari_book&BookId=1&KBN=1&PageId=135823&PN0=0&TP=1&SPA=210"

story = []
next_line = false
catch (:done) do
  while true
    last_url = url

    open(url) do |u|
      warn "reading '#{url}'..."
      # extract story
      u.each_line do |line|
        if next_line
          story << line
          next_line = false
        end
        
        if line.match(/div class="content"/)
          next_line = true
        end

        # extract next url or stop if at end
        if line.match(/li class="next"/)
          if m = line.match(/href="(.*?)"/)
            url = m[1]
          end
        end
        
      end
    end

    break if url == last_url
  end
end

# replace linebreaks, remove tags
story.each do |page|
  page.gsub!(/<br>/, "\n")
  page.gsub!(/<.+?>/, "")
end

puts story.join("\n -> \n\n")
