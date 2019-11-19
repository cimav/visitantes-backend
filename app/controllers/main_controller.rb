class MainController < ApplicationController

  # before_action :auth_required

  def index
  end

  def grid

    inicial = DateTime.parse(params[:inicial]).beginning_of_day rescue nil
    final = DateTime.parse(params[:final]).end_of_day rescue nil
    apellido = params[:apellido] if params[:apellido].present? rescue nil
    empresa = params[:empresa] if params[:empresa].present? rescue nil
    persona = params[:persona] if params[:persona].present? rescue nil

    apellido = nil if params[:apellido] == 'null'
    empresa = nil if params[:empresa] == 'null'
    persona = nil if params[:persona] == 'null'

    conditions = []
    values = []

    conditions << "(visitas.sede = #{current_user.sede})"

    if apellido
      #conditions << '(visitantes.apellido like ?)'
      conditions << '(   concat(visitantes.apellido, visitantes.nombre)    like ?)'
      values <<  "%#{apellido.strip}%"
    end
    if empresa
      conditions << '(visitantes.empresa like ?)'
      values <<  "%#{empresa.strip}%"
    end
    if persona
      conditions << '(personas.nombre like ?)'
      values << "%#{persona.strip}%"
    end
    if inicial && final
      conditions << '(entrada >= ? and (salida <= ? or salida is null))'
      values << inicial
      values <<  final
    end

    # puts conditions.join(' AND ')
    # puts *values

    @registros = Visita.includes(:visitante, :persona).where(conditions.join(' AND '), *values).references(:visitantes, :personas)

    respond_to do |format|
      format.html
      format.json
      format.xlsx {
        response.headers['Content-Disposition'] = "attachment; filename=\"visitas.xlsx\""
      }
    end

    render layout: false

  end


end
