class EmpleadosController < ApplicationController

  before_action :set_empleado, only: [:show, :update, :destroy]

  def index
    @empleados = Empleado.all.order(:nombre)

    render json: @empleados
  end

  def show
    render json: @empleado
  end

=begin
  def create

    @empleado = Empleado.new(empl_params)

    if @empleado.save
      render json: @empleado, status: :created, location: @empleado
    else
      render json: @empleado.errors, status: :unprocessable_entity
    end
  end

  def update
    if @empleado.update(empl_params)
      render json: @empleado
    else
      render json: @empleado.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @empleado.destroy
  end
=end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_empleado
    @empleado = Empleado.find(params[:id]) rescue nil
  end

  # Only allow a trusted parameter "white list" through.
  def empl_params
    params.require(:@empleado).permit(:nombre)
  end

end
