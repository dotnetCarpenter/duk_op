class Calendar

  attr_reader :filter_categories, :filter_locations, :events, :in_progress

  def initialize(type = :coming)
    @days = {}
    @filter_categories = {}
    @filter_locations = {}
    @in_progress = EventContainer.new
    if type == :coming
      get_coming_events
      get_coming_categories
      get_coming_locations
    end
  end

  # Accessor method - convert the days hash we use
  # internally into an array of day objects
  # sorted asc
  def days
    @days.values.sort {|x,y| x.date <=> y.date}
  end

  private

  # Create a hash consisting of the locations
  # present within this calendar, together with
  # their count
  def get_coming_locations
    @events.each do |e|
      next unless e.location.present?
      if @filter_locations.has_key? e.location.display_name
        @filter_locations[e.location.display_name] += 1
      else
        @filter_locations.store(e.location.display_name, 1)
      end
    end
  end

  # Convert the Active Relation returned from
  # the categories query into a hash containing
  # category keys and number of occurrences
  def get_coming_categories
    Category.current_categories.each do |cat|
     @filter_categories.store(cat['key'].to_sym, cat['num'].to_i)
    end
  end

  # Based on the dates of the events given
  # by the current_events method, sort them into
  # Day objects. If an event date is already present,
  # add it to the events for that day. Otherwise,
  # create a new Day object
  def get_coming_events
    @events = Event.current_events
    @events.each do |e|
      # if event has a start time < now
      # add to current event container
      if e.in_progress?
        @in_progress.add_event(e)
      else
        start_date = e.start_time.to_date
        if @days.has_key? start_date
          @days[start_date].add_event(e)
        else
          d = Day.new(e)
          @days.store(d.date, d)
        end
      end
    end
    self
  end



end