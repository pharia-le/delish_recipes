class FoodRecipes::CLI

    def call
        FoodRecipes::SCRAPER.new.make_recipes
        puts "Welcome to FoodRecipes!"
        start
    end
        
    def start   
        puts(<<~MAIN)

        Please choose a meal type below: Enter # 1-5

        1. Appetizers & Snacks
        2. Breakfast & Brunch
        3. Desserts
        4. Dinner
        5. Drinks

        MAIN

        input = gets.strip.to_i
        while !(1..5).include?(input)
            puts "ERROR: Please enter a number between 1-5."
            input = gets.strip.to_i
        end

        case input
            when 1
                input = "appetizers-and-snacks"
            when 2
                input = "breakfast-and-brunch"
            when 3
                input = "desserts"
            when 4
                input = "dinner"
            else
                input = "drinks"
        end

        choices = []

        puts ""
        puts "What recipe would you like more information on?"
        puts ""
        recipes = print_recipes(input)
        
        puts ""
        
        input = gets.strip.to_i
        while !(1..5).include?(input)
            puts "ERROR: Please enter a number between 1-5."
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
        puts "----------- #{recipe.name} - #{recipe.type} -----------"
        puts ""
        puts "Prep:           #{recipe.prep}"
        puts "Cook:          #{recipe.cook}"
        puts "Total:            #{recipe.total}"
        puts "Servings:             #{recipe.servings}"
    
        puts ""
        puts "---------------Ingredients--------------"
        puts ""
        puts "#{recipe.ingredients}"
        puts ""
    
        puts ""
        puts "---------------Directions--------------"
        puts ""
        puts "#{recipe.directions}"
        puts ""

        puts "---------------Nutrition Facts--------------"
        puts ""
        puts "#{recipe.nutrition_facts}"
        puts ""
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