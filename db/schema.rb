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

ActiveRecord::Schema.define(version: 2018_11_27_220513) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "builds", force: :cascade do |t|
    t.bigint "project_id"
    t.integer "number"
    t.integer "status", default: 0
    t.string "sha"
    t.string "batch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "branch"
    t.string "message"
    t.string "author_name"
    t.string "author_github_id"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.index ["project_id"], name: "index_builds_on_project_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "base", default: "potato-base:latest"
    t.string "name"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "build_script", default: ""
    t.text "setup_script", default: ""
    t.text "caches", default: [], array: true
    t.index ["project_id"], name: "index_images_on_project_id"
  end

  create_table "pipelines", force: :cascade do |t|
    t.string "name"
    t.bigint "project_id"
    t.bigint "image_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "script", default: ""
    t.index ["image_id"], name: "index_pipelines_on_image_id"
    t.index ["project_id"], name: "index_pipelines_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.string "git"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "repository_id"
  end

  create_table "ssh_keys", force: :cascade do |t|
    t.string "public_key"
    t.string "encrypted_private_key"
    t.string "encrypted_private_key_iv"
    t.string "fingerprint"
    t.string "name"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kind", default: 0
    t.index ["project_id"], name: "index_ssh_keys_on_project_id"
  end

  create_table "steps", force: :cascade do |t|
    t.integer "status", default: 0
    t.integer "owner_id"
    t.string "owner_type"
    t.integer "build_id"
    t.text "command"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "output", default: [], array: true
    t.integer "trigger", default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_token"
    t.string "encrypted_token_iv"
    t.integer "role", default: 0
    t.integer "github_id"
    t.string "name"
    t.string "api_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "web_hooks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "project_id"
    t.string "secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_web_hooks_on_project_id"
  end

  add_foreign_key "builds", "projects"
  add_foreign_key "images", "projects"
  add_foreign_key "pipelines", "images"
  add_foreign_key "pipelines", "projects"
  add_foreign_key "ssh_keys", "projects"
  add_foreign_key "web_hooks", "projects"
end
