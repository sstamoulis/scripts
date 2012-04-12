#!/usr/bin/env ruby
require 'rubygems'
require 'wpxml_parser'
require 'nanoc3'
require 'fileutils'
require 'awesome_print'

XML_PATH = 'daily.xml'
NANOC_PATH = '.'

class WordpressNanocImporter
  include WpxmlParser

  def initialize(source_xml_path, target_path)
    @target_path = target_path
    @blog = Blog.new(source_xml_path)
  end
  
  def run
    FileUtils.cd(@target_path) do
      site = Nanoc3::Site.new('.')

      posts = @blog.posts.map do |post|
        body = post.body
        attributes = build_post_attributes(post)
        identifier = "/#{post.slug}/"
        attributes[:techne] = :done
        [body, attributes, identifier]
      end
      puts "#{posts.size} posts..."

      # drafts = @blog.posts('draft').map do |post|
      #   body = post.body
      #   attributes = build_post_attributes(post)
      #   identifier = "/#{post.title.gsub(/[\[\]\(\)\.]/, '').gsub(/\s/, '-').downcase}/"
      #   attributes[:techne] = :wip
      #   [body, attributes, identifier]
      # end
      # posts += drafts
      # puts "#{drafts.size} drafts..."


      posts.sort_by{|_,a,_| a[:date]}.each_with_index do |p, i|
        body, attributes, identifier = p
        identifier = "/#{i+1}/"
        puts identifier
        site.data_sources[0].create_item(body, attributes, identifier)
      end
    end
  end

  private

  def build_post_attributes(post)
    {
      title: post.title, 
      date: Time.parse(post.date).strftime("%Y-%m-%d"),
      tags: post.categories.reject{|c| c =~ /Uncategorized/},
      techne: :wip,
      episteme: :speculation,
      slug: post.link.gsub(/^http.*muflax\.com\//, ''),
    }
  end
end

importer = WordpressNanocImporter.new(XML_PATH, NANOC_PATH)
importer.run
