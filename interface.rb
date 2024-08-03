# Pseudo-code:
# 1. Welcome
# 2. Display menu (list / add / delete / mark )
# 3. Get user action
# 4. Perform the right action

require_relative "./christmas.rb"
require "csv"
require "open-uri"
require "nokogiri"

puts "--------------------------"
puts "Welcome to Christmas list"
puts "--------------------------"

action = ""
gift_list = load_csv

until action == "quit"
  puts "\n"
  puts "You can [ list | add | delete | mark | idea | quit ]"
  puts "What do you want to do ?"
  print "> "
  action = gets.chomp.downcase

  case action
  when "list"
    puts "\n"
    puts "You currently have #{gift_list.length} item(s) in your list"
    list(gift_list)

  when "add"
    # ask user for gift name
    puts "\n"
    puts "What do you want to add?"
    print "> "
    user_gift_name = gets.chomp
    # ask user for gift price
    puts "\n"
    puts "What price?"
    print "> "
    user_gift_price = gets.chomp.to_i
    # build a hash with keys :name and :price and the correct values
    gift = { name: user_gift_name, price: user_gift_price, bought: false }
    # push the gift into gift_list with <<
    gift_list << gift
    puts "\n"
    puts "#{gift[:name]} has been added to your list"
    # save gift_list in csv file
    save_csv(gift_list)

  when "delete"
    puts "\n"
    list(gift_list)
    # ask user for index to remove
    puts "Which item do you want to delete?"
    print "> "
    # retrieve index
    user_index = gets.chomp.to_i - 1
    gift = gift_list[user_index]
    puts "\n"
    puts "#{gift[:name]} has been deleted from your list"
    # delete gift element in gift_list
    gift_list.delete_at(user_index)
    # save the gift_list in csv
    save_csv(gift_list)

  when "mark"
    puts "\n"
    list(gift_list)
    # ask user for index to mark
    puts "Which item have you bought (give the index)"
    print "> "
    # retrieve index
    user_index = gets.chomp.to_i - 1
    # grab the right gift in gift_list and toggle its value
    gift = gift_list[user_index]
    gift[:bought] = !gift[:bought]
    status = gift[:bought] ? "bought" : "pending"
    puts "\n"
    puts "#{gift[:name]} has been marked as #{status}"
    # save gift_list in csv
    save_csv(gift_list)

  when "idea"
    puts "\n"
    puts "What are you looking for?"
    print "> "
    keyword = gets.chomp
    # call the scrape letsy method with keyword
    puts "...Processing..."
    puts "...Processing..."
    puts "...Processing..."
    letsy_results = scrape_website(keyword)
    puts "...Processing..."
    puts "...Processing..."
    puts "...Processing..."

    # display results from letsy
    puts "\n"
    puts "Here are results for '#{keyword}':"
    list(letsy_results)
    # ask the user which item to add
    puts "Pick one to add to your list (give the number)"
    print "> "
    # retrieve index
    user_index = gets.chomp.to_i - 1
    # grab the item in Letsy results
    gift = letsy_results[user_index]
    # add the gift to gift_list
    gift_list << gift

    puts "\n"
    puts "#{gift[:name]} has been added to your list"
    # save the gift_list in the CSV
    save_csv(gift_list)

  when "quit"
    puts "\n"
    puts "Goodbye"
    puts "\n"

  else
    puts "I don't know what you mean"
  end
end
