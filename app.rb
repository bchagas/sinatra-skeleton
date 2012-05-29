require "bundler"
Bundler.setup(:default, ENV.fetch("RACK_ENV", :development))
Bundler.require

configure do
  Compass.configuration do |config|
    config.project_path = File.dirname(__FILE__)
    config.sass_dir = File.join 'views', 'stylesheets'
  end

  set :haml, { :format => :html5 }
  set :sass, Compass.sass_engine_options
end

configure do
  ::I18n.locale = 'pt'
  ::I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'config', 'locales', '*.yml').to_s]
end

get '/stylesheets/:file.css' do
  sass :"stylesheets/#{params[:file]}"
end

["/"].each do |path|
  get path do
    if path == '/'
      haml :index
    else
      haml :"#{path}"
    end
  end
end

helpers do
  def t(*args)
    I18n.t(*args)
  end

  def partial(file)
    haml :"partials/#{file}"
  end
end
