
if window.CCPEVE
  CCPEVE.requestTrust 'http://*.eve-pospy.com'
  # CCPEVE.requestTrust 'http://localhost:3000'

  subject = "[Fuel Alert] for #{$('.tower_name').text().slice(4)}"
  message = """
            Dear Member,

            Your POS is due to run out of fuel in about #{$('.time_til_empty').text()}, please refuel it within 2 days. If you do not have adequate roles to fuel your POS, please ensure you have adequate fuel in your Corp Hangar Array and respond to this mail and I will fuel it for you.

            Best Regards,
            #{$('.current_user').text().slice(13)}
            """

  $('[data-character-id]').each ->
    container = $(this)
    character_id = container.data('character-id')
    text = container.text
    info = $ '<button>',
      click: -> CCPEVE.showInfo(1377, character_id)
      text: 'show info'
      class: 'gray smaller'
    button = $ '<button>',
      click: -> CCPEVE.sendMail(character_id, subject, message)
      text: 'Send notice'
      class: 'smaller'
    container.prepend info, button
