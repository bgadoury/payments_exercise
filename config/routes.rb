Rails.application.routes.draw do
  resources :loans, defaults: {format: :json} do
    resources :payments, defaults: {format: :json}, only: [:create, :show, :index]
  end
end
