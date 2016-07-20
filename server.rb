require "sinatra"
require "pry"
require "csv"
require 'sinatra/flash'
enable :sessions

get "/" do
  @articles = CSV.readlines('article.csv')
  erb :index
end


get "/articles/new" do
  erb :articles_new
end

post "/articles/new" do
  title = params[:title]
  description = params[:description]
  url = params[:url]
  article = [title, description, url]

  if [title, description, url].any? { |input| input == "" }
    flash[:error] = "Please fill in all required fields."
    redirect '/articles/new'
  elsif existing_articles = CSV.readlines('article.csv')
    existing_articles.any? { |article| article[0] == title}
    flash[:error] = "This article has already been added."
    redirect '/articles/new'
  else

  CSV.open('article.csv', 'a') do |file|
    file << article
  end

  redirect '/'
  end
end

get "/articles" do
  @articles = CSV.readlines('article.csv')
  erb :index
end
