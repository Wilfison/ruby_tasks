# frozen_string_literal: true

require 'dbus'

class NotifySend
  @@interface = nil

  DEFAULTS = {
    app_name: __FILE__,
    id: 0,
    icon: 'info',
    summary: '',
    body: '',
    actions: [],
    hints: {},
    timeout: 2000
  }.freeze

  def self.send(first, *others)
    if first.is_a?(Hash) && others.length.zero?
      _send first
    elsif first.respond_to?(:to_s) && others.length < 4
      _send %i[body icon timeout].zip(others).each_with_object({ summary: first }) { |(k, v), obj|
              unless v.nil?
                obj[k] =
                  v
              end
            }
    else
      raise ArgumentError, 'Invalid arguments'
    end
  end

  def self.interface
    @@interface ||= get_interface
  end

  def self.get_interface
    bus = DBus::SessionBus.instance
    obj = bus.service('org.freedesktop.Notifications').object '/org/freedesktop/Notifications'
    obj.introspect
    obj['org.freedesktop.Notifications']
  end

  def self._send(params)
    interface.Notify(*DEFAULTS.merge(params).values)
  end
end
