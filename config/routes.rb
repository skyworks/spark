Spark::Application.routes.draw do
  match '/'                   => 'page#index',          via: [:get, :post]
end
