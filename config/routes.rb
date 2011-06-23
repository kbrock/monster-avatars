Monsters::Application.routes.draw do
  #root :to => "welcome#index"
  resources :avatars
  resources :monsters, :to => "avatars", :mode => 'key'
end
