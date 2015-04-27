Rails.application.routes.draw do

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
        post '/search' => 'search#create'
        post '/profile_extensions' => 'profile_extension#create'
      end
  end

  root 'help#index'

end
