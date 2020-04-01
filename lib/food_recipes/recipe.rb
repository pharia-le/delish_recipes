class FoodRecipes::Recipe

    attr_accessor :name, :type, :url, :yields, :prep, :total, :ingredients, :directions
    @@all = []

    def self.new_from_type(html, type)
        15.times do |i|
            if html.css(".full-item-content a")[i].attr("href").include?("/recipes/")
                self.new(
                html.css(".full-item-content a")[i].text,
                type,
                "https://www.delish.com#{html.css(".full-item-content a")[i].attr("href")}",
                )
            end
        end
    end

    def initialize(name=nil, type=nil, url=nil)
        @name = name
        @type = type
        @url = url
        self.save
    end

    def yields
        @yields ||= doc.css(".yields-amount").text.tr("\n", "").tr("\t","")
    end

    def prep
        @prep_time ||= doc.css(".prep-time-amount").text.tr("\n", "").strip.squeeze
    end

    def total
        @total_time ||= doc.css(".total-time-amount").text.tr("\n", "").strip.squeeze
    end

    def ingredients
        ingredient_list = []
        doc.css(".ingredient-lists").each do |ele|
            ele.css(".ingredient-item").each do |item|
                ingredient = item.css(".ingredient-amount").text + item.css(".ingredient-description").text
                ingredient_list << ingredient.squeeze.gsub("\n\t", " ").squeeze.strip
            end
        end
        ingredient_list
    end

    def directions
        directions = []
        doc.css(".direction-lists ol").each do |ele|
            ele.css("li").map(&:text).each do |item|
                directions << item.strip
            end
        end
        directions
    end

    def self.find(input)
        arr = self.all.select {|recipe| recipe.type == input}
        arr
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