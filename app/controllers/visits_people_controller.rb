class VisitsPeopleController < ApplicationController

  def people

    @people = VisitPeople.where("visit_id = ?", params[:visit_id]).to_json rescue nil

    respond_to do |format|
      format.html
      format.json {
        render json: @people
      }
    end

  end


  # PATCH/PUT /visits_people/1
  # PATCH/PUT /visits_people/1.json
  def update
    respond_to do |format|

      @visit = VisitPeople.find(params[:id]) rescue nil

      if @visit.update(visit_params)
        format.json { render json: @visit, status: :ok, location: @visit }
      else
        format.json { render json: @visit.errors, status: :unprocessable_entity }
      end
    end
  end

  private


  def visit_params
    params.require(:visit_people).permit(:id, :visit_id, :name, :person_type, :check_in, :check_out)
  end


end