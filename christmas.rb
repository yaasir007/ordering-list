def list(gift_list)
  gift_list.each_with_index do |gift, index|
    status = gift[:bought] ? "[X]" : "[ ]"
    puts "#{index + 1} - #{status} #{gift[:name]} / #{gift[:price]}$"
  end
end


def scrape_website(keyword)
  url = "https://letsy.lewagon.com/products?search=#{keyword}"
  response = URI.open(url).read
  html_doc = Nokogiri::HTML.parse(response)

  products_idea = []

  html_doc.search(".product-card").each do |element|
    product_name = element.search(".title").text.strip
    product_price = element.search(".price").text.gsub("$", "").strip.to_i
    products_idea << { name: product_name, price: product_price, bought: false }
  end

  products_idea
end

def load_csv
  filepath = File.join(__dir__, "gifts.csv")
  gifts = []

  CSV.foreach(filepath, headers: :first_row) do |row|
    gift = { name: row["name"], price: row["price"].to_i, bought: row["bought"] == "true" }
    gifts << gift
  end
  gifts
end

def save_csv(gifts)
  filepath = "gifts.csv"

  CSV.open(filepath, "wb", col_sep: ",", force_quotes: true, quote_char: '"') do |csv|
    csv << ["name", "price", "bought"]

    gifts.each do |gift|
      csv << [gift[:name], gift[:price], gift[:bought]]
    end
  end
end
