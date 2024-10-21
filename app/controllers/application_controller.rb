class ApplicationController < ActionController::Base
  rescue_from PokemonConnectionError, with: :pokemon_connection_error

  def pokemon_connection_error
    redirect_to root_path, alert: 'Não foi possível se conectar a API'
  end
end