class VisitRecord < ActiveRecord::Base

  establish_connection :"visitas_programadas_#{Rails.env}"

  self.abstract_class = true

end