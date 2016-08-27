$:.push File.expand_path("lib", File.dirname(__FILE__))

require "cuba" 
require "cuba/render" 
require 'tilt'
require "erb"
require 'json'
require 'model/post'

Cuba.plugin Cuba::Render
Cuba.plugin ActiveSupport::Inflector
Cuba.use Rack::Static, :root => "public", :urls => [
  "/js",
  "/css",
  "/images",
  "/fonts",
  "/google7d901f8d08713472.html",
  "/robots.txt",
  "/favicon.ico"
]

Cuba.define do
  on get do
    on root do
      @posts = Workaround::Blog::Post.all
      render("home")
    end

    on "archive/:year" do |year|
      @posts = Workaround::Blog::Post.all(year.to_i)
      render("archive")
    end

    on ":period/:slug" do |period, slug|
      @post = Workaround::Blog::Post.find_by_slug("#{period}/#{slug}")
      render("post")
    end

    on true do
      res.status = 404
      @title = "Mmmm no podemos encontrar el articulo"
      render("not_found")
    end
  end
end