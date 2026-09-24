# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2026_09_24_000001) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "article_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_article_categories_on_name", unique: true
    t.index ["slug"], name: "index_article_categories_on_slug", unique: true
  end

  create_table "article_tags", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "article_id"
    t.uuid "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_article_tags_on_article_id"
    t.index ["tag_id"], name: "index_article_tags_on_tag_id"
  end

  create_table "articles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "slug"
    t.string "title"
    t.boolean "public", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "body"
    t.date "date"
    t.uuid "article_category_id"
    t.index ["slug"], name: "index_articles_on_slug", unique: true
    t.index ["title"], name: "index_articles_on_title", unique: true
  end

  create_table "cdn_files", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_id"
    t.uuid "document_id"
    t.string "video_id"
    t.uuid "user_id"
    t.string "locale"
    t.string "original_file_name"
    t.index ["path"], name: "index_cdn_files_on_path"
  end

  create_table "client_side_renders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "host"
    t.string "path"
    t.string "referrer"
    t.string "user_agent"
    t.string "ip"
    t.integer "viewport_width"
    t.integer "viewport_height"
    t.uuid "server_side_render_id"
    t.uuid "browser_session_id"
    t.uuid "user_id"
    t.uuid "visit_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "companies", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "slug"
    t.string "business_name"
    t.string "address"
    t.string "emails"
    t.string "phone"
    t.string "fax"
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "legal_name"
    t.string "website"
    t.boolean "public"
    t.integer "order"
    t.string "email_general"
    t.string "email_support"
    t.string "email_orders"
    t.string "email_accounting"
    t.text "description"
    t.text "notes"
    t.boolean "is_headquarter", default: false
    t.boolean "shown_on_group_website", default: false
    t.string "core_activity"
    t.string "history"
    t.integer "rank_on_group_website", default: 999
    t.boolean "show_markets", default: true
    t.integer "head_count", default: 1
    t.boolean "shown_on_main_website", default: false
    t.boolean "shown_on_icsf_website", default: false
    t.index ["business_name"], name: "index_companies_on_business_name", unique: true
    t.index ["country_id"], name: "index_companies_on_country_id"
    t.index ["slug"], name: "index_companies_on_slug", unique: true
  end

  create_table "company_markets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "company_id"
    t.string "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rank_among_companies"
    t.integer "rank_among_countries"
    t.boolean "company_is_recommended", default: false
  end

  create_table "company_members", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "company_id"
    t.uuid "person_id"
    t.string "title"
    t.string "email"
    t.string "phone"
    t.boolean "public", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "public_title", default: false
    t.boolean "public_email", default: false
    t.boolean "public_phone", default: false
    t.integer "rank_among_companies"
    t.integer "rank_among_members"
    t.string "landline"
    t.boolean "public_landline", default: false
    t.index ["company_id"], name: "index_company_members_on_company_id"
    t.index ["person_id"], name: "index_company_members_on_person_id"
  end

  create_table "containers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_containers_on_name", unique: true
  end

  create_table "countries", primary_key: "two_letter_code", id: :string, force: :cascade do |t|
    t.string "name_english"
    t.string "name_native"
    t.string "three_letter_code"
    t.string "numeric_code"
    t.string "region"
    t.string "subregion"
    t.decimal "latitude"
    t.decimal "longitude"
    t.integer "area"
    t.integer "population"
    t.string "flag_url"
    t.string "timezones"
    t.string "top_level_domains"
    t.string "calling_codes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "country_currencies", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "country_id"
    t.uuid "currency_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_country_currencies_on_country_id"
    t.index ["currency_id"], name: "index_country_currencies_on_currency_id"
  end

  create_table "country_languages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "country_id"
    t.string "language_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_country_languages_on_country_id"
    t.index ["language_id"], name: "index_country_languages_on_language_id"
  end

  create_table "currencies", primary_key: "code", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "symbol"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "document_categories", primary_key: "slug", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "gist"
    t.string "icon"
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name_single"
  end

  create_table "documents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "path", null: false
    t.string "name"
    t.string "language_id"
    t.string "document_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "variations"
    t.boolean "public", default: false
  end

  create_table "email_attempts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "created_by_type"
    t.uuid "created_by_id"
    t.string "from"
    t.string "to"
    t.string "cc"
    t.string "bcc"
    t.string "reply_to"
    t.integer "provider"
    t.string "postmark_stream"
    t.string "postmark_template_alias"
    t.jsonb "postmark_template_model", default: {}
    t.jsonb "response_body", default: {}
    t.integer "response_status"
    t.boolean "delivered"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by_type", "created_by_id"], name: "index_email_attempts_on_created_by"
    t.index ["response_body"], name: "index_email_attempts_on_response_body", using: :gin
  end

  create_table "employees", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "company_id"
    t.uuid "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_employees_on_company_id"
    t.index ["person_id"], name: "index_employees_on_person_id"
  end

  create_table "event_attendees", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "event_id"
    t.uuid "person_id"
    t.string "first_name"
    t.string "last_name"
    t.string "role"
    t.string "company"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "locale"
  end

  create_table "events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "dates"
    t.string "city"
    t.string "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "start_date"
    t.string "end_date"
    t.boolean "has_registration_form"
    t.boolean "ask_first_name"
    t.boolean "ask_last_name"
    t.boolean "ask_role"
    t.boolean "ask_company"
    t.string "confirmation_email_subject", default: "See you soon at {event_name}!"
    t.string "confirmation_email_body", default: "Hello {first_name} {last_name},    We look forward seeing you at {event_name} on {event_date} in {event_location}.    Best regards,    The Interflux Electronics team"
    t.string "confirmation_email_bcc", default: "s.teliszewski@interflux.com, jw@interflux.au"
    t.string "website"
  end

  create_table "features", primary_key: "slug", id: :string, force: :cascade do |t|
    t.string "text"
    t.string "icon"
    t.string "gist"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "has_page"
  end

  create_table "images", primary_key: "path", id: :string, force: :cascade do |t|
    t.string "caption"
    t.string "alt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "company_id"
    t.string "variations"
    t.uuid "user_id"
    t.string "original"
    t.boolean "converting"
    t.string "conversion_error_log"
  end

  create_table "languages", primary_key: "two_letter_code", id: :string, force: :cascade do |t|
    t.string "name_english"
    t.string "name_native"
    t.string "three_letter_code"
    t.boolean "public", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leads", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "company"
    t.string "email"
    t.string "mobile"
    t.text "message"
    t.string "purpose"
    t.string "source"
    t.string "ip_region"
    t.string "ip_city"
    t.string "ip"
    t.uuid "country_id"
    t.uuid "ip_country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_leads_on_country_id"
    t.index ["ip_country_id"], name: "index_leads_on_ip_country_id"
  end

  create_table "page_views", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "path"
    t.uuid "browser_session_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "people", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "chinese_name"
    t.string "email"
    t.string "phone"
    t.boolean "male"
    t.string "full_name"
    t.string "image_id"
    t.string "avatar_path"
    t.string "avatar_variations"
    t.string "avatar_caption"
    t.string "avatar_alt"
  end

  create_table "permalinks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "slug"
    t.string "redirect_to"
    t.string "notes"
    t.uuid "event_id"
    t.index ["slug"], name: "index_permalinks_on_slug", unique: true
  end

  create_table "person_images", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "person_id"
    t.string "image_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_complementary_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "product_id"
    t.uuid "complement_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["complement_id"], name: "index_product_complementary_products_on_complement_id"
    t.index ["product_id"], name: "index_product_complementary_products_on_product_id"
  end

  create_table "product_complements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "product_id"
    t.uuid "complement_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["complement_id"], name: "index_product_complements_on_complement_id"
    t.index ["product_id"], name: "index_product_complements_on_product_id"
  end

  create_table "product_documents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "product_id"
    t.uuid "document_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rank_among_products"
    t.integer "rank_among_documents"
  end

  create_table "product_families", primary_key: "slug", id: :string, force: :cascade do |t|
    t.string "name_single"
    t.string "name_plural"
    t.integer "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "gist"
    t.string "the_full_monty"
    t.string "product_family_id"
  end

  create_table "product_features", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "product_id"
    t.string "feature_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_images", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "product_id"
    t.string "image_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rank"
    t.boolean "public"
  end

  create_table "product_qualities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "product_id"
    t.string "quality_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rank"
    t.integer "rank_among_products"
    t.integer "rank_among_qualities"
    t.boolean "show_on_product_list"
  end

  create_table "product_related_articles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "product_id"
    t.uuid "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_product_related_articles_on_article_id"
    t.index ["product_id"], name: "index_product_related_articles_on_product_id"
  end

  create_table "product_substitutes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "product_id"
    t.uuid "substitute_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_substitutes_on_product_id"
    t.index ["substitute_id"], name: "index_product_substitutes_on_substitute_id"
  end

  create_table "product_uses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "product_id"
    t.string "use_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rank_among_products"
    t.integer "rank_among_uses"
    t.boolean "show_on_product_list"
    t.string "image_id"
    t.boolean "show_alternative_avatar", default: false
  end

  create_table "product_videos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "product_id"
    t.string "video_id"
    t.integer "rank"
    t.boolean "public"
  end

  create_table "products", primary_key: "slug", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "image_id"
    t.string "label"
    t.text "pitch"
    t.text "properties"
    t.boolean "public", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "offline"
    t.string "superior_product_id"
    t.integer "rank_among_family"
    t.string "summary"
    t.string "instructions"
    t.boolean "complies_with_iso"
    t.boolean "complies_with_rohs"
    t.boolean "complies_with_iec"
    t.string "test_results"
    t.boolean "complies_with_ipcjstd004_a"
    t.boolean "complies_with_ipcjstd004_b"
    t.boolean "complies_with_ipcjstd005"
    t.string "avatar_path"
    t.string "avatar_variations"
    t.string "avatar_caption"
    t.string "avatar_alt"
    t.boolean "on_front_page", default: false
    t.integer "front_page_rank", default: 9
    t.string "main_family_id"
    t.string "sub_family_id"
  end

  create_table "qualities", primary_key: "slug", id: :string, force: :cascade do |t|
    t.string "text"
    t.string "icon"
    t.text "gist"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_id"
  end

  create_table "server_side_renders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "host"
    t.string "path"
    t.string "referrer"
    t.string "user_agent"
    t.string "ip"
    t.uuid "visit_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sessions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "href"
    t.string "referrer"
    t.string "ip"
    t.string "ip_country_id"
    t.string "ip_timezone"
    t.string "ip_isp"
    t.string "browser_app"
    t.string "browser_width"
    t.string "browser_height"
    t.string "browser_languages"
    t.uuid "user_id"
    t.boolean "is_interflux_member", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ip_response_code"
    t.string "ip_response_body"
    t.integer "ip_request_duration"
  end

  create_table "simulation_requests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "project_name"
    t.string "pallet_width"
    t.string "pallet_length"
    t.string "wave_speed"
    t.string "cycle_time"
    t.string "flux_brand"
    t.string "flux_consumption"
    t.string "board_reference"
    t.string "known_issue"
    t.string "solder_process"
    t.string "flux_process"
    t.string "full_name"
    t.string "email"
    t.string "company_name"
    t.string "image"
    t.integer "sequence"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "tags", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "slug"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_tags_on_slug", unique: true
  end

  create_table "translations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "location"
    t.string "language"
    t.string "native"
    t.string "english"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.text "english_before"
    t.string "error"
    t.index ["language", "location"], name: "unique_location_per_language_index", unique: true
    t.index ["language"], name: "index_translations_on_language"
    t.index ["location"], name: "index_translations_on_location"
  end

  create_table "use_images", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "use_id"
    t.string "image_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rank_among_uses"
    t.integer "rank_among_images"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.uuid "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "abilities"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "uses", primary_key: "slug", id: :string, force: :cascade do |t|
    t.string "text"
    t.string "icon"
    t.text "gist"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_id"
    t.integer "rank"
  end

  create_table "videos", primary_key: "path", id: :string, force: :cascade do |t|
    t.string "variations"
    t.string "title"
    t.string "notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "visits", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "host"
    t.string "path"
    t.string "referrer"
    t.string "user_agent"
    t.string "ip"
    t.string "ip_isp"
    t.string "ip_country_id"
    t.integer "viewport_width"
    t.integer "viewport_height"
    t.boolean "is_interflux"
    t.boolean "is_bot"
    t.uuid "browser_session_id"
    t.uuid "user_id"
    t.datetime "first_seen"
    t.datetime "last_seen"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "webinar_attendees", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "webinar_id"
    t.uuid "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "webinar_images", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "webinar_id"
    t.uuid "image_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "webinar_invitees", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "webinar_id"
    t.uuid "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "webinar_videos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "webinar_id"
    t.uuid "video_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "webinars", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.string "topic"
    t.string "audience"
    t.string "url"
    t.boolean "public", default: false
    t.bigint "start_time"
    t.integer "duration"
    t.uuid "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_id"
    t.string "video_id"
    t.string "document_id"
  end

end
