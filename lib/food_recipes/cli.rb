class FoodRecipes::CLI

    def call
        puts "Welcome to Food Recipes!"
        FoodRecipes::SCRAPER.new.make_recipes
        start
    end

    def start   
        puts(<<~MAIN)
       
        Please choose a meal type below: Enter # 1-4

        1. Dinner
        2. Dessert
        3. 30 Minute Meals
        4. Cocktails

        MAIN

        input = gets.strip.to_i
        while !(1..4).include?(input)
            puts "ERROR: Please enter a number between 1-4."
            input = gets.strip.to_i
        end

        case input
            when 1
                input = "weeknight-dinners"
            when 2
                input = "dessert-recipes"
            when 3
                input = "content/30-minute-meals/"
            else
                input = "content/cocktail-recipes/"
        end
        
        choices = []

        puts ""
        puts "What recipe would you like more information on?"
        puts ""

        recipes = print_recipes(input)
        
        puts ""
        input = gets.strip.to_i
        while !(1..recipes.size).include?(input)
            puts "ERROR: Please enter a number between 1-#{recipes.size}."
            input = gets.strip.to_i
        end
        
        print_recipe(recipes[input-1])

        puts ""
        puts "Would you like to see another recipe? Enter Y or N"
        puts ""

        input = gets.strip.downcase
        if input == "y"
            start
        elsif input == "n"
            puts ""
            puts "Thank you! Have a great day!"
            exit
        else
            puts ""
            puts "I don't understand that answer."
            start
        end
    end

    def print_recipe(recipe)
        puts ""
        puts "----------- #{recipe.name} -----------"
        puts ""
        puts "Yields:              #{recipe.yields}"
        puts "Prep Time:           #{recipe.prep}"
        puts "Total Time:          #{recipe.total}"
    
        puts ""
        puts "--------------- Ingredients --------------"
        puts ""
        recipe.ingredients.each {|ingredient| puts ingredient}
        puts ""
    
        puts ""
        puts "--------------- Directions --------------"
        puts ""
        recipe.directions.each.with_index(1) do |direction, i| 
            puts "#{i}) #{direction}"
        end
        puts ""
        
        puts ""
        puts "--------------- About Author: #{recipe.author_info[0]} --------------"
        puts ""
        puts recipe.author_info[1]

    end

    def print_recipes(input)
        counter = 1
        FoodRecipes::Recipe.all.select do |recipe|
            if recipe.type == input
                puts "#{counter}. #{recipe.name}"
                counter +=1
            end
        end
    end
end