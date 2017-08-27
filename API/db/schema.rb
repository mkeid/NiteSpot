# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130630063727) do

  create_table "avatars", :force => true do |t|
    t.string   "location"
    t.integer  "group_id"
    t.integer  "place_id"
    t.integer  "service_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cabs", :force => true do |t|
    t.string   "name"
    t.integer  "phone_number"
    t.integer  "school_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "cabs_schools", :force => true do |t|
    t.integer  "cab_id"
    t.integer  "school_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "group_memberships", :force => true do |t|
    t.boolean  "accepted",   :default => true
    t.boolean  "is_admin"
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "group_memberships", ["user_id", "group_id"], :name => "index_group_memberships_on_user_id_and_group_id"

  create_table "groups", :force => true do |t|
    t.string   "handle",              :limit => 25
    t.string   "name"
    t.string   "group_type"
    t.boolean  "public",                            :default => true
    t.integer  "school_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  ":avatar_file_size"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
  end

  add_index "groups", ["handle"], :name => "index_groups_on_handle"

  create_table "invitations", :force => true do |t|
    t.integer  "party_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "network_requests", :force => true do |t|
    t.integer  "school_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "notifications", :force => true do |t|
    t.integer  "from_group"
    t.integer  "from_party"
    t.integer  "from_user"
    t.string   "message"
    t.boolean  "unchecked",         :default => true
    t.string   "notification_type"
    t.string   "shout_liked"
    t.integer  "group_id"
    t.integer  "place_id"
    t.integer  "service_id"
    t.integer  "user_id"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "ordered_products", :force => true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "orders", :force => true do |t|
    t.string   "comment"
    t.float    "ns_bill"
    t.time     "order_time"
    t.float    "service_bill"
    t.integer  "service_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "parties", :force => true do |t|
    t.string   "address"
    t.string   "description"
    t.string   "name"
    t.boolean  "public"
    t.datetime "time"
    t.integer  "group_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "places", :force => true do |t|
    t.boolean  "active",                    :default => false
    t.string   "email",      :limit => 25
    t.string   "handle",     :limit => 25
    t.string   "name"
    t.boolean  "owned",                     :default => false
    t.string   "salt",       :limit => 100
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  add_index "places", ["handle"], :name => "index_places_on_handle"

  create_table "places_schools", :id => false, :force => true do |t|
    t.integer  "place_id"
    t.integer  "school_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "products", :force => true do |t|
    t.integer  "cost"
    t.integer  "group_id"
    t.string   "label"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.boolean  "accepted",    :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "requests", :force => true do |t|
    t.integer  "from_group"
    t.integer  "from_user"
    t.string   "request_type"
    t.string   "group_id"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "school_memberships", :force => true do |t|
    t.integer  "school_id"
    t.integer  "user_id"
    t.boolean  "is_primary", :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "schools", :force => true do |t|
    t.string   "email_extension"
    t.string   "handle",          :limit => 25
    t.string   "name"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "schools", ["handle"], :name => "index_schools_on_handle"

  create_table "schools_services", :force => true do |t|
    t.integer  "school_id"
    t.integer  "service_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "services", :force => true do |t|
    t.string   "email",        :limit => 25
    t.string   "handle",       :limit => 25
    t.string   "label"
    t.string   "name"
    t.boolean  "owned",                       :default => false
    t.string   "password",     :limit => 40
    t.string   "phone_number", :limit => 20
    t.string   "salt",         :limit => 100
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  add_index "services", ["handle"], :name => "index_services_on_handle"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "shout_likes", :force => true do |t|
    t.integer  "shout_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "shout_likes", ["shout_id", "user_id"], :name => "index_shout_likes_on_shout_id_and_user_id", :unique => true
  add_index "shout_likes", ["shout_id"], :name => "index_shout_likes_on_shout_id"
  add_index "shout_likes", ["user_id"], :name => "index_shout_likes_on_user_id"

  create_table "shouts", :force => true do |t|
    t.string   "message",             :limit => 130
    t.string   "reference_name"
    t.integer  "referenced_group_id"
    t.integer  "referenced_party_id"
    t.integer  "referenced_place_id"
    t.string   "shout_type"
    t.integer  "group_id"
    t.integer  "place_id"
    t.integer  "service_id"
    t.integer  "user_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "user_attendances", :force => true do |t|
    t.integer  "user_id"
    t.integer  "party_id"
    t.integer  "place_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_favorites", :force => true do |t|
    t.integer  "cab_id"
    t.integer  "service_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.boolean  "active",                             :default => false
    t.string   "activation_token"
    t.string   "email",               :limit => 100
    t.string   "gender",              :limit => 6
    t.string   "handle",              :limit => 25
    t.string   "password"
    t.integer  "party_id"
    t.integer  "place_id"
    t.string   "salt"
    t.integer  "school_id"
    t.string   "name_first",          :limit => 20
    t.string   "name_last",           :limit => 20
    t.string   "privacy",             :limit => 7
    t.string   "year",                :limit => 9
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
  end

end
