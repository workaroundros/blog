$:.push File.expand_path("lib", File.dirname(__FILE__))

require "cuba" 
require "cuba/render" 
require 'tilt'
require "erb"
require 'json'
require 'active_support/core_ext/string'
require 'active_support/core_ext/numeric/time'
require 'model/post'

Cuba.plugin Cuba::Render
Cuba.plugin ActiveSupport::Inflector
Cuba.use Rack::Static, :root => "public", :urls => ["/js", "/css", "/images", "/fonts", "/google7d901f8d08713472.html"]

Cuba.define do
  on get do
    on root do
      @posts = Workaround::Blog::Post.all
      render("home")
    end

    on "read/:slug" do |slug|
      @post = Workaround::Blog::Post.find_by_slug(slug)
      render("post")
    end

    on true do
      res.status = 404
      @title = "Mmmm no podemos encontrar el articulo"
      render("not_found")
    end
  end
end