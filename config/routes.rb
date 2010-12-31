Sims::Application.routes.draw do
  match '/doc/' => 'doc#index', :as => :doc

  resources :unattached_interventions do
    member do
      put :update_end_date
    end

  end

  resources :grouped_progress_entries do
    member do
      get :aggregate
    end

  end

  resources :flag_descriptions
  resources :school_teams
  resources :consultation_form_requests
  resources :consultation_forms

  resources :team_consultations do
    member do
      put :complete
    end

  end

  match '/stats' => 'main#stats', :as => :stats
  match '/spell_check/' => 'spell_check#index', :as => :spell_check
  match '/change_password' => 'login#change_password', :as => :change_password
  match '/file/:filename' => 'file#download', :as => :download_file, :constraints => { :filename => /[^\/;,?]+/ }
  match '/preview_graph/:intervention_id' => 'interventions/probe_assignments#preview_graph', :as => :preview_graph
  resources :help
  resources :quicklist_items
  resources :tiers do
    member do
      put :move
    end
  end

  resources :user_school_assignments
  namespace :district do
    resources :schools
    resources :users
    resources :students do
      collection do
        get :check_id_state
      end
    end
    resources :flag_categories
  end

  namespace :school do
    resources :students
  end

  resources :custom_probes
  resources :news_items
  resources :principal_overrides do
    member do
      put :undo
    end
  end

  match '/logout' => 'login#logout', :as => :logout
  resources :groups do
    member do
      delete :remove_user
      get :add_student_form
      get :show_special
      post :add_student
      delete :remove_special
      delete :remove_student
      get :add_special_form
      get :add_user_form
      post :add_special
      post :add_user
    end
  end

  resources :checklists
  resources :recommendations
  resources :student_comments
  match '/custom_flags/delete/:id' => 'custom_flags#destroy', :as => :delete_custom_flag
  resources :custom_flags
  resources :enrollments
  resources :students do
    collection do
      post :member_search
      post :select
      post :grade_search
      get :search
    end
  end

  resources :schools do
    collection do
      post :select
    end


  end
  resources :users
  resources :districts do
    collection do
      get :bulk_import_form
      get :export
      get :bulk_import
    end
    member do
      get :logs
      put :reset_password
      put :recreate_admin
    end
  end

  namespace :checklist_builder do
    resources :checklists do
      resources :questions do
        resources :elements do
          resources :answers do
            member do
              post :move
            end
          end
        end
      end
    end
  end

  namespace :intervention_builder do
    resources :probes do
      member do
        put :disable
      end

    end
    resources :goals do
      resources :objectives do
        resources :categories do
          resources :interventions do
            collection do
              post :sort
            end
            member do
              put :move
              put :disable
            end
          end
        end
      end
    end
  end

  namespace :interventions do
    resources :goals do
      resources :objectives do
        resources :categories do
          resources :definitions do
            collection do
              post :select
            end
          end
        end
      end
    end
  end

  resources :interventions do
    resources :comments
    resources :participants
    resources :probe_assignments do
      resources :probes do
        collection do
          get :new_assessment
          get :update_assessment
          post :save_assessment
        end
      end
    end
  end

  match '/' => 'main#index'
  match '/:controller(/:action(/:id))'
end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
   #root :to => "main#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
