require 'haml'
require 'sinatra'
require 'marky_markov'

require 'util'

class RabbleRouser < Sinatra::Base
  DEFAULT_MARKOV_ORDER = 2

  set :root, File.join(File.dirname(__FILE__), '..')
  set :public_folder, File.join(root, 'public')

  configure do
    set :markov, {}
  end

  get '/favicon.ico' do
    ''
  end

  get '/?:count?' do
    @count = (params[:count] || rand(5) + 1).to_i
    @markov = pick_markov(params[:order])
    haml :index
  end

  def pick_markov(order)
    order ||= DEFAULT_MARKOV_ORDER
    order = order.to_i
    order = 1 if order < 1
    order = 5 if order > 5
    puts "Picking #{order}"
    settings.markov[order] ||= build_markov(order)
  end

  def build_markov(order)
    puts "Building #{order}"
    Util.build_dictionary("markov.#{order}", order)
  end
end
