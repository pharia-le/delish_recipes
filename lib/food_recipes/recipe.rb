class FoodRecipes::Recipe

    attr_accessor :name, :type, :url, :doc, :prep, :cook, :total, :servings, :ingredients, :directions, :nutrition_facts

    @@all = []

    def self.new_from_type(html, type)
        5.times do |i|
            self.new(
            html.css(".fixed-recipe-card__title-link")[i*2].text.strip,
            type,
            html.css(".grid-card-image-container a")[i*2].attr("href"),
            )
        end
    end

    def initialize(name=nil, type=nil, url=nil)
        @name = name
        @type = type
        @url = url
        self.save
    end

    def  prep
        @prep ||= doc.css(".prepTime__item")[1].text.strip
    end

    def cook
        @cook ||= doc.css(".prepTime__item")[2].text.strip
    end
        
    def total
        @total ||= doc.css(".prepTime__item")[3].text.strip
    end

    def servings
        @servings ||= doc.css("#metaRecipeServings").attr("content").value
    end

    def ingredients
        @ingredients ||= doc.css(".checkList__line").text.squeeze.gsub("\r\n", "").squeeze[1..-54].split(", ") 
    end

    def directions
        @directions ||= doc.css(".recipe-directions__list--item").text.gsub("\r\n", "").split(".")
    end
    
    def nutrition_facts
        @nutrition_facts ||= doc.css(".nutrition-summary-facts").text.squeeze.gsub("\r\n", "")
    end

    def self.find(input)
        self.all.detect {|recipe| recipe.name == input}
    end

    def self.all
        @@all
    end

    def save
        @@all << self
    end

    def doc
        @doc ||= Nokogiri::HTML(open(self.url))
      end
end