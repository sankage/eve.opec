
if window.CCPEVE
  # CCPEVE.requestTrust 'http://*.eve-pospy.com'
  CCPEVE.requestTrust 'http://localhost:3000'

  subject = "Test"
  message = "This is a test of an alert system."

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
