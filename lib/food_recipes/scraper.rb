class FoodRecipes::SCRAPER

    def make_recipes
        types = ["weeknight-dinners", "dessert-recipes", "content/30-minute-meals/", "content/cocktail-recipes/"]
        types.each do |type|
            html = Nokogiri::HTML(open("https://www.delish.com/#{type}"))
            new_from_type(html,type)
        end 
    end

    def new_from_type(html, type)
        15.times do |i|
            if !html.css(".full-item a")[i].values[0].include?("/g")
                FoodRecipes::Recipe.new(
                    html.css("div.full-item-title.item-title")[i].text,
                    type,
                    "https://www.delish.com#{html.css(".full-item a")[i].attr("href")}"
                )
            end
        end
    end
end
