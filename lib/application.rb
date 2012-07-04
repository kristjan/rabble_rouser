require 'sinatra'
require 'haml'

class RabbleRouser < Sinatra::Base
  set :root, File.join(File.dirname(__FILE__), '..')
  set :public_folder, File.join(root, 'public')

  get '/' do
    haml :index
  end
end
