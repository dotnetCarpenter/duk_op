When(/^a user visits the home page$/) do
  visit root_path
end
Given (/^an event with title "(.*)" and short description "(.*)" has been created$/) do |title, description|
  @event_details = { title: title,
                    creator: 'FestAbe99',
                    short_description: description,
                    location: 'ungdomshuset',
                    start_time: DateTime.new,
                    end_time: DateTime.new,
                    category: 'party' }
  Event.create(@event_details)
end

Then(/^they should see events$/) do
  page.has_selector?('.event-container')
end

And(/^the text "(.*)" should be visible$/) do |text|
  page.has_text?(text, visible: true)
end

But(/^the text "(.*)" should be hidden$/) do |text|
  page.has_text?(text, visible: false)
end

And(/^they click on the (.*) link$/) do |name|
  click_link(name)
end

Then(/^the form "([^"]*)" should be visible$/) do |id|
  selector = '#' + id
  page.has_selector?(selector, visible: true)
end

When(/^they fill in the form$/) do
  within '#new_event' do
    fill_in 'event_title', with: 'Sample title'
    fill_in 'event_creator', with: 'Sample creator'
    fill_in 'event_short_description', with: 'Some gibberish'
    select 'folkets', from: 'event_location'
    select 'party', from: 'event_category'
    now = DateTime.now
    select now.year, from: 'event_start_time_1i'
    select now.strftime('%B'), from: 'event_start_time_2i'
    select now.day, from: 'event_start_time_3i'
    select now.hour, from: 'event_start_time_4i'
    select now.minute, from: 'event_start_time_5i'

    select now.year, from: 'event_end_time_1i'
    select now.strftime('%B'), from: 'event_end_time_2i'
    select now.day + 1, from: 'event_end_time_3i'
    select now.hour, from: 'event_end_time_4i'
    select now.minute, from: 'event_end_time_5i'

    click_button 'Create'
  end
end