class Visit < VisitRecord

  self.table_name = "visits"

  has_many :visit_people

end