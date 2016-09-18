require "sinatra"
require "sqlite3"
require "chunky_png"
require_relative "./number_png"

DATABASE_FILE = "pageviews.db"

create_tables = !File.exist?(DATABASE_FILE)

db = SQLite3::Database.new(DATABASE_FILE)

if create_tables
  db.execute <<-SQL
CREATE TABLE pageviews (
  name varchar(255),
  count int
);
SQL
end

get "/pv/:name.png" do
  name = params[:name]
  result = db.execute "SELECT count FROM pageviews WHERE name = ?", name
  existing_count = result.empty? ? 0 : result[0][0]
  new_count = existing_count + 1

  if existing_count == 0
    db.execute "INSERT INTO pageviews VALUES (?, ?)", name, new_count
  else
    db.execute "UPDATE pageviews SET count = ? WHERE name = ?", new_count, name
  end

  status 200
  content_type 'image/png'
  cache_control :no_store
  NumberPNG.new(new_count.to_s.rjust(7, "0")).to_png_blob
end

get "/webring" do
  webring_users = Dir.glob("/home/*")
  template_index_file = "/usr/share/skel/public_html/index.html"

  webring_users = Dir.glob("/home/*").select do |home|
    index_file = "#{home}/public_html/index.html"
    File.exists?(index_file) &&
      !FileUtils.identical?(index_file, template_index_file)
  end.map do |home|
    File.basename(home)
  end

  if params[:random]
    destination_user = webring_users.sample
  else
    if params[:after]
      offset = 1
    elsif params[:before]
      offset = -1
    else
      status 422
      return
    end

    current_user = params[:after] || params[:before]
    current_index = webring_users.index(current_user)
    next_index = (current_index + offset) % webring_users.size
    destination_user = webring_users[next_index]
  end

  redirect "http://meow.town/~#{destination_user}"
end
