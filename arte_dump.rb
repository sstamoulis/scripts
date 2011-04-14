#!/usr/bin/ruby -w
# coding: utf-8
# Copyright muflax <mail@muflax.com>, 2010
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

require "open-uri"

lang = "de"

ARGV.each do |url| 
    arte_path = "/home/amon/映画/arte"
    target = "#{arte_path}/#{File::basename(url).sub(".html", ".flv")}"

    site = open(url)

    # find the swf player and next xml file
    player = rtmp = site2 = site3 = ""
    site.each do |line| 
        if m = line.match(%r|http://videos\.arte\.tv.*?\.swf|)
            player = m[0]
        elsif m = line.match(%r|http://.*?\,view\,asPlayerXml\.xml|)
            site2 = open(m[0])
        end
    end

    # find final xml file
    site2.each do |line| 
        if m = line.match(%r|http://videos\.arte\.tv/#{lang}.*?\,view\,asPlayerXml\.xml|)
            site3 = open(m[0])                     
            break
        end
    end

    # find rtmp address
    site3.each do |line| 
        if line.match(/quality="hd"/)
            rtmp = line[/rtmp:.*(?=<\/url>)/]
            break
        end
    end

    # finally download
    system("rtmpdump --rtmp '#{rtmp}' --swfVfy '#{player}' --flv '#{target}'")
end

# delete .swfinfo
File.delete("/home/amon/.swfinfo")
