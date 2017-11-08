class NetmultixRecord < ActiveRecord::Base

  establish_connection :"#{Rails.env}_cimavnetmultix"

  self.abstract_class = true

end