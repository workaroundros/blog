module Workaround
  module Blog
    class Post
      include ActiveSupport::Inflector
      attr_accessor :author, :abstract, :created_at, :title

      def initialize(params)
        @title = params[:title]
        @abstract = params[:abstract]
        @created_at = Date.parse(params[:created_at])
        @author = params[:author]
      end

      def slug
        title.to_s.downcase.underscore.gsub(' ','_').dasherize
      end

      def body
        # read this body content from an static file
        # something like File.read('some-file')
        "This is the post body "*(500)
      end

      def self.all
        # mocked method until we make a desicion about where the post source will be
        [].tap do |posts|
          10.times do |x|
            posts << new({
              :title      => "Post title #{x}",
              :created_at => (Date.today).to_s,
              :author => %w(uke aboyon leo guido gonzo).sample,
              :abstract => "Abstract content "*(100),
            })
          end
        end
      end

      def self.find_by_slug(slug)
        # mocked method until we make a desicion about where the post source will be
        new({
          :title => slug.humanize,
          :created_at => (Date.today - 2.days).to_s,
          :abstract => "Na na na",
          :author => %w(uke aboyon leo guido gonzo).sample
        })
      end

    end
  end
end