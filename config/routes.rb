Rails.application.routes.draw do
  # Api defination
  namespace :api, defaults: { format: :json} do
    namespace :v1 do

    end
  end
end
