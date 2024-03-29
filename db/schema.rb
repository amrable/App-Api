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

ActiveRecord::Schema.define(version: 2021_12_18_165620) do

  create_table "applications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "token", limit: 36, null: false
    t.string "name", null: false
    t.integer "chats_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.timestamp "last_request_timestamp"
    t.index ["token"], name: "index_applications_on_token"
  end

  create_table "chats", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "application_id"
    t.integer "number"
    t.integer "messages_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.timestamp "last_request_timestamp"
    t.string "title"
    t.index ["application_id", "number"], name: "index_chats_on_application_id_and_number"
    t.index ["application_id"], name: "index_chats_on_application_id"
  end

  create_table "messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "chat_id"
    t.integer "number"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.timestamp "last_request_timestamp"
    t.index ["chat_id", "number"], name: "index_messages_on_chat_id_and_number"
    t.index ["chat_id"], name: "index_messages_on_chat_id"
  end

  add_foreign_key "chats", "applications"
  add_foreign_key "messages", "chats"
end
