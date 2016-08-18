class Notifier
  attr_reader :notifier

  def initialize
    @notifier = Slack::Notifier.new(Rails.application.secrets.slack_webhook_url)
  end

  def check_for_notification(tower)
    if tower.online? && tower.hours_til_empty < 24
      send_fuel_alert(tower)
    end

    if tower.online? && !tower.secure? && !tower.excluded?
      send_insecure_alert(tower)
    end
  end

  def tower_state_change(previous, current, tower)
    return if previous == current
    send_state_change_alert(tower, previous, current)
  end

  private

  def admin_channel
    Rails.application.secrets.slack_admin_channel || general_channel
  end

  def general_channel
    Rails.application.secrets.slack_general_channel
  end

  def send_fuel_alert(tower)
    notifier.ping "", channel: general_channel,
      attachments: attachment(
        title: 'Fuel Alert',
         text: "#{tower.name} is running low on fuel. #{tower.pilots.pluck(:name).to_sentence}: please refuel it soon."
      )
  end

  def send_insecure_alert(tower)
    notifier.ping "<!group> #{tower.name}: is not secure!",
      channel: admin_channel,
      attachments: attachment(
        title: 'Security Warning',
         text: "#{tower.name} is currently not secure! It currently allows more access then it should."
      )
  end

  def send_state_change_alert(tower, previous, current)
    notifier.ping "<!group> #{tower.name}: status change",
      channel: admin_channel,
      attachments: attachment(
        title: 'Tower State Change',
        text: "#{tower.name} has changed state from #{previous} to #{current}.\nLocated at #{tower.moon.name}"
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
