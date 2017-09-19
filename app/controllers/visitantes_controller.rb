class VisitantesController < ApplicationController
  before_action :set_visitante, only: [:show, :update, :destroy]

  # GET /visitantes
  def index
#    @visitantes = Visitante.all

#    @visitantes = Visitante.joins(:visitas).where('visitas.salida is NOT null') rescue nil
    @visitantes = Visitante.where("id NOT IN(select visitante_id from visitas where salida is null)");

    render json: @visitantes

    # @question = Question.where(category_id: @category.id) .where("id NOT IN(select question_id from memories where user_id = ?)",

  end

  def avatar
    send_file "public/avatars/#{params[:id]}/avatar.png" , type: 'image/jpg', disposition: 'inline' rescue send_file "public/not_found.jpg" , type: 'image/jpg', disposition: 'inline'
    #render text:'Holax'
  end

  def subir

    uploader = AvatarUploader.new

    uploader.store!(my_file)

  end

  def upload_foto=(file_field)
    self.name = base_part_of(file_field.original_filename)
    self.data = file_field.read
    self.image_url = Rails.root + "/public/uploads/" + self.name
  end

  def base_part_of(file_name)
    File.basename(file_name).gsub(/[^\w._-]/, '')
  end

  # GET /visitantes/1
  def show
    #render :json => @visitante.to_json(:include => :visitas)
    render json: @visitante
  end

  def last
    visitante = Visitante.find(params[:id]) rescue nil
    if visitante
      visita = Visita.includes(:persona).where(:visitante_id => params[:id]).order(:entrada => :desc).first rescue nil
      if visita
        if visita.persona
          visitante = visitante.attributes.merge({visita: visita.attributes.merge({persona: visita.persona})})
        else
          visitante = visitante.attributes.merge({visita:visita})
        end
      end
    end
    render json: visitante
  end
  #render :json => @todo.attributes.merge({list: { "completion_percentage" => 63 }})


=begin
  def adentro
    # visitantes = Visitante.joins(:visitas).where('visitas.salida is not null') rescue nil # regresa los que tienen al menos UN NO nulo
    # visitantes = Visitante.joins(:visitas).where('visitas.salida is null') rescue nil # regresa los que tienen al menos UN SI nulo

    #render :json =>  Visitante.joins(:visitas).where("visitas.id >3").to_json(:include => {:visitas => {:include => :empleado} })

    # render :json => visitantes.to_json(:include => {:visitas => {:include => :empleado} })

   # visitantes = Visitante.joins(:visita).where('visitas.salida is null').references(:visitas)

    # visitantes = Visitante.joins(:visitas).where(visitas: {id: 5})
#    visitantes = Visitante.(:visitas).where('visitas.salida is null').references(:visitas)

    #visitantes = Visitante.joins("INNER JOIN visitas ON visitas.visitante_id = visitantes.id").where('visitas.salida is null')

    #render :json => visitantes.to_json(:include => {:visitas => {:include => :empleado} })


    visitantes = Visitante.joins("INNER JOIN visitas ON visitas.visitante_id = visitantes.id").where('visitas.salida is null')


    visitantes = Visitante.select('*').joins(:visitas).where('visitas.salida is null')

    render :json => visitantes.to_json



    #render :json => visitantes.to_json(:include => {:visitas => {:include => :empleado} })

  end
=end

  # POST /visitantes
  def create
  #  image_data = JSON.parse(params[:json])['visita']['avatar']
  #  params[:visita][:avatar] = @visita.convert_from_base64(image_data)

    @visitante = Visitante.new(visita_params)

  #  @visita.avatar= Base64.encode64(File.read('public/1.jpg'));

    if @visitante.save
      render json: @visitante, status: :created, location: @visitante
    else
      render json: @visitante.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /visitantes/1
  def update
    if @visitante.update(visita_params)
      render json: @visitante
    else
      render json: @visitante.errors, status: :unprocessable_entity
    end
  end

  # DELETE /visitantes/1
  def destroy
    @visitante.destroy
  end

  def count
    answer = Visitante.count(:id) rescue -1
    render json: answer
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_visitante
      @visitante = Visitante.find(params[:id]) rescue nil
    end

    # Only allow a trusted parameter "white list" through.
    def visita_params
      params.require(:visitante).permit(:rfc, :apellido, :nombre, :avatar, :nota, :persona, :tipo)
    end
end
