class FoodRecipes::SCRAPER

    def make_recipes
        
        types = ["weeknight-dinners", "dessert-recipes", "content/30-minute-meals/", "content/cocktail-recipes/"]
        types.each do |type|
            html = Nokogiri::HTML(open("https://www.delish.com/#{type}"))
            FoodRecipes::Recipe.new_from_type(html,type)
        end 
    end

end
