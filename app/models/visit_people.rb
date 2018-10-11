class VisitPeople < VisitRecord

  self.table_name = "visit_people"

  belongs_to :visit

end