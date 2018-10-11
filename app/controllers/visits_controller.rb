class VisitsController < ApplicationController

  def index
            # d /m / y
    fecha = '01/10/2018'.to_datetime # Date.today

    # "DATE(date) >= ?", fecha

    @visits = Visit.includes(:visit_people).select(:id, :institution, :resp_name, :date, :status).where("DATE(date) >= ? AND status=3",fecha).order("visit_people.person_type DESC, visit_people.name") rescue nil

    # @visits = Visit.includes(:visit_people).select(:id, :institution, :resp_name, :date, :status).where("date = ? AND status=3", Date.today).order("visit_people.name") rescue nil

    render json: @visits, include: :visit_people
=begin
    respond_to do |format|
      format.html
      format.json {
        render json: @visits, include: :visit_people
      }
    end
=end

  end

  private

  def visit_params
    params.require(:visit).permit(:id, :institution, :resp_name, :status, :date)
  end


end