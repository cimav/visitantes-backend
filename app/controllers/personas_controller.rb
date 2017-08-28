class PersonasController < ApplicationController

  def index

    personas = Persona.all

    render json: personas
  end

  def create
    Persona.create(person_params)
  end

  private
  def person_params
    params.require(:persona).permit(:id, :clave, :nombre, :tipo, :sede)
  end
end


