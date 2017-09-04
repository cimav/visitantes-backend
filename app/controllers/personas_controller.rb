class PersonasController < ApplicationController

  def index

    personas = Persona.all.order(:nombre)

    render json: personas
  end

  def proveedores

    personas = Persona.where("tipo = 2 AND sede = :sede", {:sede=>params[:sede]}).order(:nombre)

    render json: personas
  end

  private
  def person_params
    params.require(:persona).permit(:id, :clave, :nombre, :tipo, :sede)
  end
end


