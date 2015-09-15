class Notifier
  attr_reader :notifier

  def initialize
    @notifier = Slack::Notifier.new(Rails.application.secrets.slack_webhook_url)
  end

  def check_for_notification(tower)
    if tower.online? && tower.hours_til_empty < 24
      send_fuel_alert(tower)
    end

    if tower.online? && !tower.secure?
      send_insecure_alert(tower)
    end
  end

  def tower_state_change(previous, current, tower)
    return if previous == current
    send_state_change_alert(tower, previous, current)
  end

  private

  def send_fuel_alert(tower)
    notifier.ping "", channel: '#pospy-private', attachments: attachment(
      title: 'Fuel Alert',
       text: "#{tower.name} is running low on fuel. #{tower.pilots.pluck(:name).to_sentence}: please refuel it soon."
    )
  end

  def send_insecure_alert(tower)
    notifier.ping "<!group>", channel: '#pospy-council', attachments: attachment(
      title: 'Security Warning',
       text: "#{tower.name} is currently not secure!"
    )
  end

  def send_state_change_alert(tower, previous, current)
    notifier.ping "<!group>", channel: '#pospy-council', attachments: attachment(
      title: 'Tower State Change',
       text: "#{tower.name} has changed state from #{previous} to #{current}."
    )
  end

  def attachment(title:, text:)
    [{
      fallback: text,
      pretext: "",
      color: "#D00000",
      fields: [{
        title: title,
        value: text,
        short: false
      }]
    }]
  end
end
