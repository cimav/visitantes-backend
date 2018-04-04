class VisitantesController < ApplicationController

#  skip_before_action :verify_authenticity_token  # avoid CSRF - 422 (Unprocessable Entity)
# protect_from_forgery unless: -> { request.format.json? }

  before_action :set_visitante, only: [:show, :update, :destroy]

  # GET /visitantes
  # GET /visitantes.json
  def index

    # @visitantes = Visitante.joins(:visitas).where('visitas.salida is NOT null') rescue nil
    @visitantes = Visitante.where("id NOT IN(select visitante_id from visitas where salida is null)");

    render json: @visitantes

    # @question = Question.where(category_id: @category.id) .where("id NOT IN(select question_id from memories where user_id = ?)",

  end

  def avatar
    send_file "public/avatars/#{params[:id]}/avatar.png" , type: 'image/jpg', disposition: 'inline' rescue send_file "public/not_found.jpg" , type: 'image/jpg', disposition: 'inline'
  end

  def thumb
    begin
      send_file "public/avatars/#{params[:id]}/thumb_avatar.png" , type: 'image/jpg', disposition: 'inline'
    rescue => ex
      # si no hay thumb, llama al avatar
      avatar
    end
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

    @visitante = Visitante.find(params[:id])
    render @visitante
  end

  # GET /visitantes/1/edit
  def edit
    @tipos= [['Visitante', 0],['Estudiante', 1],['Proveedor', 2],['Contratista', 3],['Sub-contratista', 4],['Ex-empleado', 5],['Familiar', 6],['Otro', 7]]
    # @tipos= [0,1,2,3,4,5,6,7,8,9]
    # @tipos = [{:name => "Cero", :id => 0}, {:name => "Uno", :id => 1}, {:name => "Tres", :id => 3}]

    @visitante = Visitante.find(params[:id]) rescue nil
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

  # GET /visitantes/new
  def new
    @visitante = Visitante.new
  end

  # POST /visitantes
  # POST /visitantes.json
  def create
  #  image_data = JSON.parse(params[:json])['visita']['avatar']
  #  params[:visita][:avatar] = @visita.convert_from_base64(image_data)

    @visitante = Visitante.new(visitante_params)

  #  @visita.avatar= Base64.encode64(File.read('public/1.jpg'));

    if @visitante.save
      render json: @visitante, status: :created, location: @visitante
    else
      render json: @visitante.errors, status: :unprocessable_entity
    end

=begin
    respond_to do |format|
      if @visitante.save
        format.html { redirect_to @visitante, notice: 'Visitante was successfully created.' }
        format.json { render :show, status: :created, location: @visitante }
      else
        format.html { render :new }
        format.json { render json: @visitante.errors, status: :unprocessable_entity }
      end
    end
=end

  end

  # PATCH/PUT /visitantes/1
  # PATCH/PUT /visitantes/1.json
  def update

=begin
    if @visitante.update(params[:visitante])
      render json: @visitante
    else
      render json: @visitante.errors, status: :unprocessable_entity
    end
=end

    respond_to do |format|
      if @visitante.update(visitante_params)
        format.html { redirect_to root_path, notice: 'Visitante was successfully updated.' }
        format.json { render :show, status: :ok, location: @visitante }
      else
        format.html { render :edit }
        format.json { render json: @visitante.errors, status: :unprocessable_entity }
      end
    end

  end

  # DELETE /visitantes/1
  # DELETE /visitantes/1.json
  def destroy
    @visitante.destroy

=begin
    respond_to do |format|
      format.html { redirect_to visitantes_url, notice: 'Visitante was successfully destroyed.' }
      format.json { head :no_content }
    end
=end

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
    def visitante_params
      params.require(:visitante).permit(:rfc, :apellido, :nombre, :avatar, :empresa, :nota, :tipo, :persona)
    end
end
