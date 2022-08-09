# frozen_string_literal:true

require 'csv'

# comment to avoid RuboCop
class SongsController < ApplicationController
  SongReducer = Rack::Reducer.new(
    Song.all,
    ->(album:) { where('lower(album) like ?', "%#{album.downcase}") },
    ->(title:) { where('lower(title) like ?', "%#{title.downcase}") },
    ->(year:) { where(year: year) }
  )

  def index
    song = SongReducer.apply(params)
    render json: song.all.as_json(except: %i[created_at updated_at])
  end

  def create
    CSV.foreach('db/FavZepAlbums.csv', headers: :first_row) do |col|
      Song.create(album: col[0],
                  title: col[1],
                  year: col[2])
    end
    render json: Song.all.as_json(except: %i[created_at updated_at])
  end
end
