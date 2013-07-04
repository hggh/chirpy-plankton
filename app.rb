$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'sinatra'
require 'erb'
require 'password_exchange'
require 'securerandom'


helpers do
  def base_url
    @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
  end
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

before do
  if !request.secure? and Sinatra::Base.production?
    halt 400, "Please use SSL at https://#{request.env['HTTP_HOST']}"
  end
end


get '/' do
 config = PasswordExchange::Config.new('conf/password_exchange.yaml')
 access = PasswordExchange::Access.new(config)
 access.access?(request.ip, request.user_agent)

 erb :index
end

get '/receive/:keyname' do
  config = PasswordExchange::Config.new('conf/password_exchange.yaml')
  access = PasswordExchange::Access.new(config)
  access.access?(request.ip, request.user_agent)
  begin
    storage = PasswordExchange::Storage.new(config)
    @password_value = storage.get_value(params[:keyname])
  rescue PasswordExchange::Storage::ErrorKeyNotFound
    @password_value = nil
    @password_error = true
  end
  erb :receive
end

get '/insert' do
  config = PasswordExchange::Config.new('conf/password_exchange.yaml')
  access = PasswordExchange::Access.new(config)
  access.access?(request.ip, request.user_agent)

  erb :insert
end

post '/insert' do
  config = PasswordExchange::Config.new('conf/password_exchange.yaml')
  access = PasswordExchange::Access.new(config)
  access.access?(request.ip, request.user_agent)
  @keyname = nil
  if params[:password_text] and params[:password_text] != ""
    storage = PasswordExchange::Storage.new(config)
    @keyname = storage.set_value(params[:password_text].delete('\n'))
  else
    redirect "#{@base_url}/insert"
  end
  erb :insert_success
end
