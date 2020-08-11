require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

# initialize DB in project
set :database, 'sqlite3:barbershop.db'

#method table.save is smart (can validate)
class Client < ActiveRecord::Base
  # validates pr1(typeSym), pr2(typeHash if pr2 alone can use without { } )
  validates :name, presense => true
  validates :phone, presense => true
  validates :datestamp, presense => true
  validates :color, presense => true
end

class Barber < ActiveRecord::Base
end

class Contant < ActiveRecord::Base
end

before '/' do
  @barbers = Barber.all
  # @barbers = Barber.order 'created_at DESC'     // sorted by time of creating, start with end
end

get '/' do
  erb :index
end

get '/sublist' do
  @subscribers = Client.order("created_at DESC")
  erb :sublist
end

get '/subscriber/:id' do
  # find current client from DB 
  @subscriber = Client.find(params[:id])
  erb :subscriber
end

get '/barber/:id' do
  # find current barber from DB 
  @barber = Barber.find(params[:id])
  erb "barber personal page"
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

  # good way to write field of view from DB
  # c = Client.new params[:client]
  # c.save
  # in view the visit_form must be write input attr name ="client[here name of field in current DB Clients = name, phone, datestamp.. (see field in migrate directory"

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


  # write to db input fields (lame way)
  c = Client.new
  c.name = @clientname
  c.phone = @userphone
  c.bareber = @master
  c.datestamp = @userdate
  c.color = @color
  c.save

  # c.valid?
  # c.errors.messages  (return { :name => [ok/not ok], :phone => [ok/not ok]...})
  if c.save
    erb "<h2>Спасибо, Вы записались</h2>"
  else
    @errors = c.errors.full_messages.first # 
    # erb "<h2>Упс, записаться не получилось, проверьте поля ввода</h2>"
    erb :visit_form
  end
end   
