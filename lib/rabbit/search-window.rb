require 'rabbit/gtk'

require 'rabbit/searcher'

module Rabbit
  class SearchWindow

    attr_accessor :window, :direction, :entry
    def initialize(canvas)
      @canvas = canvas
      @searcher = Searcher.new(canvas)
      init_window
    end

    def show
      send_focus_change(true)
      @window.show
    end

    def hide
      send_focus_change(false)
      @window.hide
    end

    def forward=(forward)
      @direction.active = forward
    end

    def forward?
      @direction.active?
    end

    def empty?
      /\A\s*\z/ =~ @entry.text
    end

    def regexp
      @searcher.regexp(@entry.text)
    end

    private
    def init_window
      @window = Gtk::Window.new(:popup)
      @window.modal = true
      init_frame
      init_box
      init_entry
      init_direction
    end

    def init_frame
      @frame = Gtk::Frame.new
      @frame.shadow_type = :etched_in
      @frame.show
      @window.add(@frame)
    end

    def init_box
      @box = Gtk::Box.new(:horizontal)
      @box.border_width = 3
      @box.show
      @frame.add(@box)
    end

    def init_entry
      @entry = Gtk::Entry.new
      @entry.show
      @box.add(@entry)
    end

    def init_direction
      @direction = Gtk::ToggleButton.new
      @arrow = Gtk::Arrow.new(:left, :none)
      @arrow.show
      @direction.add(@arrow)
      @direction.can_focus = false
      @direction.show
      @box.add(@direction)
      @direction.signal_connect("toggled") do |button|
        if forward?
          type = :right
        else
          type = :left
        end
        @arrow.set(type, :none)
      end
      @direction.active = true
    end

    def send_focus_change(focus_in)
      @entry.has_focus = focus_in
      event = Gdk::EventFocus.new(:focus_change)
      event.window = @entry.window
      event.in = focus_in
      @entry.event(event)
      @entry.notify("has-focus")
    end
  end
end
