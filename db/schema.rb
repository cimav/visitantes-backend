# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170324191222) do

  create_table "empleados", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "nombre"
  end

  create_table "pets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.text     "description", limit: 65535
    t.string   "image"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "visitantes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "rfc"
    t.string   "apellido"
    t.string   "nombre"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "avatar"
    t.string   "empresa"
    t.text     "nota",       limit: 65535
  end

  create_table "visitas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.datetime "entrada"
    t.datetime "salida"
    t.text     "nota",         limit: 65535
    t.integer  "visitante_id"
    t.integer  "empleado_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["empleado_id"], name: "index_visitas_on_empleado_id", using: :btree
    t.index ["visitante_id"], name: "index_visitas_on_visitante_id", using: :btree
  end

end
