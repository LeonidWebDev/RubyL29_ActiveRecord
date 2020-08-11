require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, 'sqlite3:barbershop.db'

class Client < ActiveRecord::Base
end

class Barber < ActiveRecord::Base
end

class Contant < ActiveRecord::Base
end

get '/' do
  # @barbers = Barber.all
  # @barbers = Barber.order 'created_at DESC'     // sorted by time of creating, start with end
  erb :index
end

get '/visit_form' do
  erb :visit_form
end

get '/contacts' do
  erb :contacts
end

post '/contacts' do
  @mail = params[:mail]
  @message = params[:message]

  hh = {:mail => "Введите mail",
        :message => "Введите message"}
  
  hh.each do |key, value|
    if params[key] == ""
      @error = hh[key]
      return erb :visit_form
    end
  end

  if @error != ""
    erb :contacts
  end  
 
  co = Contact.new (
    { :mail => params[:mail],
      :message => params[:message]
    }
  )
  co.save

  return erb "<h2>Спасибо, за message</h2>"

end   

post '/visit_form' do
  @master = params[:master]
  @clientname = params[:clientname]
  @userphone = params[:userphone]
  @userdate = params[:userdate]
  @color = params[:colorpicker]

  hh = {:clientname => "Введите имя",
        :userphone => "Введите номер телефона",
        :userdate => "Введите время посещения"}
  
  hh.each do |key, value|
    if params[key] == ""
      @error = hh[key]
      return erb :visit_form
    end
  end

  if @error != ""
    erb :visit_form
  end  
 
  # c = Client.new (
  #   { :name => params[:clientname],
  #     :phone => params[:userphone],
  #     :barber => params[:master],
  #     :datestamp => params[:userdate],
  #     :color => params[:color]
  #   }
  # )
  # c.save

  c = Client.new
  c.name = @clientname
  c.phone = @userphone
  c.bareber = @master
  c.datestamp = @userdate
  c.color = @color
  c.save

  return erb "<h2>Спасибо, Вы записались</h2>"

end   
