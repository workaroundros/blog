require 'nokogiri'
require 'active_support/core_ext/string'
require 'active_support/core_ext/numeric/time'

module Workaround
  module Blog
    class Post
      include ActiveSupport::Inflector
      attr_accessor :author, :abstract, :created_at, :title, :file, :period

      ARTICLES_FOLDER = "blog-articles"

      def slug
        title.to_s.strip.downcase.underscore.gsub(' ','_').dasherize
      end

      def body
        File.read(file)
      end

      def self.all(year = Date.today.year)
        [].tap do |posts|
          Dir.glob("#{ARTICLES_FOLDER}/#{year}/*.html").map do |article|
            posts << parse_post(article)
          end
        end
      end

      def self.find_by_slug(slug)
        parse_post("#{ARTICLES_FOLDER}/#{slug.strip.downcase}.html")
      end

      def self.parse_post(file)
        doc = File.open(file) { |f| Nokogiri::HTML(f) }
        metadata = doc.xpath('//comment()')
        new.tap do |post|
          post.file = file
          post.period = File.basename(File.dirname(file))
          post.abstract = doc.xpath('//p').first.text
          if metadata
            post.title = metadata[0].text.strip
            post.author = metadata[1].text.strip
            post.created_at = Date.parse(metadata[2].text.strip)
          end
        end
      end

      def self.count(year)
        Dir.glob("#{ARTICLES_FOLDER}/#{year}/*.html").size
      end

    end
  end
end