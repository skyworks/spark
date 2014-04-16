Spark::Application.routes.draw do
  root  :to => 'page#index' 
  match '/'                   => 'page#index',          via: [:get, :post]
  match '/about'              => 'page#about',          via: [:get, :post]
  match '/settings'           => 'page#settings',       via: [:get, :post]

  match '/login'              => 'page#login',          via: [:get, :post]
  match '/register'           => 'page#register',       via: [:get, :post]
  get   '/logout'             => 'page#logout'
  
  match '/ideas'              => 'page#ideas',          via: [:get, :post]
  match '/idea/:idea_id'      => 'page#idea',           via: [:get, :post]
  match '/idea/create'        => 'page#create_idea',    via: [:get, :post]
  match '/idea/:idea_id/edit' => 'page#edit_idea',      via: [:get, :post]

end
