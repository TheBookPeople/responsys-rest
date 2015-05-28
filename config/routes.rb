Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      post '/search' => 'search#create'
      post '/profile_extensions' => 'profile_extension#create'
      post '/trigger_campaign_message' => 'trigger_campaign_message#create'
      post '/merge_list_members' => 'list#create'
      get '/status' => 'status#index'
    end
  end

  root 'help#index'
end
