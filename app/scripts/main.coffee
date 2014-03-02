EVENTFUL_API_KEY = 'fWhzvRX8MxP35pNx'
ECHONEST_API_KEY = 'CXWHF3RAFXNLY9EHI'
EVENTFUL_ENDPOINT = 'http://api.eventful.com/json/events/search'
ECHONEST_ENDPOINT = 'http://developer.echonest.com/api/v4/playlist/static'
MONTHS = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']


# Bind event handlers when DOM is ready
$(document).ready ->
  $('#search-bar').keypress (event) ->
    if event.which == 13
      fetchEventData this.value


# Fetches event data for the given location string
fetchEventData = (location) ->
  $.ajax
    url: EVENTFUL_ENDPOINT
    type: 'GET'
    dataType: 'jsonp'
    data:
      app_key: EVENTFUL_API_KEY
      where: location
      category: 'music'
      sort_order: 'popularity'
    success: handleEventData


# Parses event data from the Eventful API into a useable form for displaying
handleEventData = (eventData) ->
  eventfulArtistIds = []
  eventsData = []

  for event in eventData.events.event
    location = event.city_name + ', ' + event.region_abbr
    venue = event.venue_name
    date = prettyDate event.start_time
    url = event.url
    image = event.image.url.replace 'small', 'block250'
    performers = []

    if event.performers
      if event.performers.performer instanceof Array
        for performer in event.performers.performer
          performers.push performer.name
          eventfulArtistIds.push 'eventful:artist:' + performer.id
      else
        performers.push event.performers.performer.name
        eventfulArtistIds.push 'eventful:artist:' + event.performers.performer.id

    eventsData.push
      location: location
      venue: venue
      date: date
      url: url
      image: image
      performers: performers

  displayEvents eventsData
  fetchPlaylistData eventfulArtistIds.unique()[0...5]
  fetchPlaylistData eventfulArtistIds.unique()[5...10]


# Displays event data to the user
displayEvents = (events) ->
  for event in events
    div = $('<div />',
      class: 'event col-sm-6 center-block'
    )

    a = $('<a />',
      class: 'event-image-shadow'
    )

    img = $('<img />',
      src: event.image
      class: 'event-image'
    )

    body = $('<div />',
      class: 'event-body'
      html: '<span class="event-performer">' + event.performers.join(', ') + '</span><br>' +
            '<span class="event-venue">' + event.venue + '</span><br>' +
            '<span class="event-location">' + event.location + '</span><br>' +
            '<a href="' + event.url + '"><span class="event-date">' + event.date + '</span></a>'
    )

    a.append img
    div.append(a).append body
    $('#events').append div


# Fetches playlist data for the given Eventful artist IDs
fetchPlaylistData = (eventfulArtistIds) ->
  $.ajax
    url: ECHONEST_ENDPOINT
    type: 'GET'
    dataType: 'jsonp'
    traditional: 'true'
    data:
      api_key: ECHONEST_API_KEY
      artist: eventfulArtistIds
      variety: 1
      format: 'jsonp'
      results: 20
      type: 'artist'
      bucket: ['id:spotify-US', 'tracks', 'audio_summary']
      adventurousness: 0
    success: handlePlaylistData


# Parses playlist data from the Echo Nest API into a useable form for displaying
handlePlaylistData = (playlistData) ->
  spotifyTrackIds = []
  for song in playlistData.response.songs
    if song.tracks.length
      spotifyTrackIds.push song.tracks[0].foreign_id.split(':')[2]

  displayPlaylist spotifyTrackIds


# Displays playlist data to the user
displayPlaylist = (spotifyTrackIds) ->
  spotifyFrame = $('#spotify-frame')
  if spotifyFrame.length != 0
    spotifyFrame.appendAttr 'src', ',' + spotifyTrackIds.join(',')
  else
    $('<iframe />',
      src: 'https://embed.spotify.com/?theme=white&uri=spotify:trackset:Gigify:' + spotifyTrackIds.join ','
      frameborder: '0'
      allowtransparency: 'true'
      id: 'spotify-frame'
    ).appendTo '#spotify-player'


# Removes duplicate elements from an array
Array::unique = ->
  output = {}
  output[@[key]] = @[key] for key in [0...@length]
  value for key, value of output


# Appends a suffix to a jQuery object's attribute
$.fn.appendAttr = (attrName, suffix) ->
  @attr attrName, (i, val) ->
    val + suffix
  this


# Formats dates of the form "YYYY-MM-DD HH:MM:SS" into the form "Month Day, Year"
prettyDate = (date) ->
  date = date.split(' ')[0]
  year = date.split('-')[0]
  month = date.split('-')[1]
  day = date.split('-')[2]
  "#{MONTHS[parseInt(month) - 1]} #{day}, #{year}"
