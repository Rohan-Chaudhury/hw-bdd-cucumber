# Add a declarative step here for populating the DB with movies.

Given (/the following movies exist:/) do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here
    # Movie.connection.execute("INSERT INTO movies (title, rating, release_date) VALUES ('#{movie[:title]}','#{movie[:rating]}','#{movie[:release_date]}')")
    Movie.create!(title: movie[:title],rating: movie[:rating],release_date:  movie[:release_date])
  end
  # fail "Unimplemented"
end

Then (/(.*) seed movies should exist/) do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then (/I should see "(.*)" before "(.*)"/) do |a, b|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  # log(page.find('div', text: e1)).value)
  # log(page.find('div', text: e2)).value)
  first_pos=page.body.index(a)
  second_pos=page.body.index(b)
  expect(first_pos).to be < second_pos
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings=rating_list.split(', ')
  for rating in ratings do
    if uncheck
      uncheck("ratings[#{rating}]")
    else
      check("ratings[#{rating}]")
    end
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  #fail "Unimplemented"
  rows=page.find_all(:xpath, '//*[@id="movies"]//tbody//tr').size

  row_count=Movie.all.size

  expect(rows).to eq row_count
end





When (/I press the "(.*)" button/) do |b|
  click_on(b)  
  
end


Then (/I should see all the following movies: (.*)$/) do |e1|
  movies = e1.split(', ')
  for movie in movies do
      expect(page).to have_content(movie)
  end
end


Then (/I should not see all the following movies: (.*)$/) do |e1|
  movies = e1.split(', ')
  for movie in movies do
      expect(page).not_to have_content(movie)
  end
end



