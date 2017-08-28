class VisitasController < ApplicationController
  before_action :set_visitante, only: [:show, :update, :destroy]

  def index
    @visitas = Visita.all.order(entrada: :desc)

    render json: @visitas

  end

  # POST /visitas
  def create

    @visita = Visita.new(visita_params)

    @visita.entrada = DateTime.now

    if @visita.save
      render json: @visita, status: :created, location: @visita
    else
      render json: @visita.errors, status: :unprocessable_entity
    end
  end

  def last
    render json: Visita.where(:visitante_id => params[:visitante_id]).order(:entrada => :desc).first.to_json(:include => :persona)
  end

  def show
    render json: Visita.find(params[:id]).to_json(:include => :visitas) rescue nil
  end

  def adentro

    result = Visita.where('salida IS NULL and sede = :sede', {:sede=>params[:sede]})

    render json: result.to_json(:include => [:persona, :visitante])


    #Visitante.select('*').joins(:visitas).where('visitas.salida is null')

  end

  # PATCH/PUT /visitas/1
  def update

    vis_params = visita_params

    if vis_params[:salida]
      vis_params[:salida] = Time.current
    end

    if @visita.update(vis_params)
      render json: @visita
    else
      render json: @visita.errors, status: :unprocessable_entity
    end
  end

  # DELETE /visitas/1
  def destroy
    @visita.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_visitante
    @visita = Visita.find(params[:id]) rescue nil
  end

  # Only allow a trusted parameter "white list" through.
  def visita_params
    params.require(:visita).permit(:entrada, :salida, :visitante_id, :persona_id, :nota, :gafete, :sede)
  end
end
