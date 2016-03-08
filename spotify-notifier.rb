require "bundler/setup"
Bundler.require(:default)
require "active_support"
require "active_support/core_ext"
Dotenv.load
RSpotify.authenticate(ENV["SPOTIFY_KEY"], ENV["SPOTIFY_SECRET"])

user = RSpotify::User.new({
  "id" => "krasnoukhov",
  "credentials" => {
    "token" => ENV["SPOTIFY_USER_TOKEN"],
    "refresh_token" => ENV["SPOTIFY_USER_REFRESH_TOKEN"],
  },
})

artists = []
last_artist_id = nil

while batch = user.following(type: "artist", limit: 50, after: last_artist_id)
  artists = artists.concat(batch)

  if batch.count < 50
    break
  else
    last_artist_id = batch.last.id
  end
end

puts "Artists: #{artists.count}"

all_albums = artists.flat_map do |artist|
  albums = []
  offset = 0

  while batch = artist.albums(limit: 20, offset: offset, album_type: "album,single")
    if (ids = batch.map(&:id)).any?
      albums = albums.concat(RSpotify::Album.find(ids))
    end

    if batch.count < 20
      break
    else
      offset = offset + 20
    end
  end

  albums
end

puts "Albums: #{all_albums.count}"

titles = all_albums.sort_by(&:release_date).select do |x|
  x.available_markets.include?("US")
end.reverse.take(200).select do |x|
  Date.parse(x.release_date).between?(1.day.ago.to_date, 1.day.from_now.to_date)
end.map do |album|
  "#{album.release_date} - #{album.artists.map(&:name).join(", ")} - #{album.name} - #{album.external_urls["spotify"]}"
end.uniq

puts titles
