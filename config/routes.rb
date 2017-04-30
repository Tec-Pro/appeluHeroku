Rails.application.routes.draw do
  
  namespace :api, defaults: { format: "json"  } do
    namespace :v1 do
      resources :users, only: [:create, :index, :show, :destroy]
      resources :shifts, except: [:new, :edit]
      resources :businesses, except: [:new, :edit] do
      	resources :services, except: [:new, :edit]
      	resources :days, controller: "customer_service_days", except: [:new, :edit]
      end 

       put "/users", to: "users#update"
       post "/login", to: "users#login"
       post "/users/recovery", to: "users#recovery"
		   
 

		  get "/services", to: "services#indexAll"
		  get "/myReserves", to: "users#shifts"
		     
    end
  end
  
  match "*path", :to => "application#routing_error", :via => :all
  match '/users' => "users#options", via: :options


end

