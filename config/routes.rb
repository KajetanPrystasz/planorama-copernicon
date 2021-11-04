require "sidekiq/web"

# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  devise_for :people, path: 'auth',
             controllers: {
               sessions: 'people/sessions',
               passwords: 'people/passwords',
               registrations: 'people/registrations'
             }, defaults: { format: :json }

  root to: 'home#index'

  # TODO: we will need to rework the magic link for SPA routing
  get '/login/:magic_link', to: 'login#magic_link'

  # REST based resources
  get 'session/me', to: 'people#me'
  get 'person/me', to: 'people#me'
  get 'people/me', to: 'people#me'
  resources :people, path: 'person' do
    resources :person_roles, path: 'person_role', shallow: true
    resources :email_addresses, path: 'email_address', shallow: true
    resources :submissions, path: 'submission', shallow: true
  end

  get 'person/:person_id(/survey/:survey_id)/submissions', to: 'people#submissions'
  # For now mailed and assigned are the same, at some point they will not be
  get 'person/:person_id/mailed_surveys', to: 'people#mailed_surveys'
  get 'person/:person_id/assigned_surveys', to: 'people#assigned_surveys'

  resources :bios, path: 'bio'
  resources :programme_items, path: 'programme_item'
  resources :programme_assignments, path: 'programme_assignment'
  resources :rooms, path: 'room'
  resources :venues, path: 'venue'
  resources :tag_contexts, path: 'tag_context'
  resources :configurations, path: 'configuration'
  resources :parameter_names, path: 'parameter_name'

  resources :mailings, path: 'mailing'
  resources :mail_templates, path: 'mail_template'

  get 'agreement/signed', to: 'agreements#signed'
  get 'agreement/unsigned', to: 'agreements#unsigned'
  put 'agreement/sign/:id', to: 'agreements#sign'
  get 'agreement/latest', to: 'agreements#latest'
  resources :agreements, path: 'agreement'

  # Surveys and their nested resources
  post 'survey/:survey_id/assign_people', to: 'surveys#assign_people'
  post 'survey/:survey_id/unassign_people', to: 'surveys#unassign_people'

  resources :surveys, path: 'survey' do
    scope module: 'survey' do
      resources :pages, path: 'page', shallow: true do
        scope module: 'page' do
          resources :questions, path: 'question', shallow: true do
            scope module: 'question' do
              resources :answers, path: 'answer', shallow: true
            end
          end
        end
      end
      resources :submissions, path: 'submission', shallow: true
      delete 'submission', to: 'submissions#delete_all'
    end
  end

  # Shallow versions of the create endpoints ...
  post 'page', to: 'survey/pages#create'
  patch 'page', to: 'survey/pages#create'
  post 'question', to: 'survey/page/questions#create'
  patch 'question', to: 'survey/page/questions#create'
  post 'answer', to: 'survey/page/question/answers#create'
  patch 'answer', to: 'survey/page/question/answers#create'

  # NOTE: if we want submisisons sans surveys fill in the only
  resources :submissions, path: 'submission', only: [] do
    scope module: 'submission' do
      resources :responses, path: 'response', shallow: true
    end
  end

  get 'rbac', to: 'rbac#index'

  # Access to the sidekiq monitoring app...
  # authenticate :person, lambda { |p| p.admin? } do
  #   mount Sidekiq::Web => '/sidekiq'
  # end

  # force everything back to the SPA home page
  # This has to be at the end otherwise we do not match the resource endpoints
  # as this is a catch all
  match '*path' => redirect('/'), via: :get
end
