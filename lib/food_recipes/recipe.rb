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
        @prep_time ||= doc.css(".prep-time-amount").text.tr("\n", "").squeeze
    end

    def total
        @total_time ||= doc.css(".total-time-amount").text.tr("\n", "").squeeze
    end

    def ingredients
        arr = doc.css(".ingredient-lists").each do |ingredient|
            ingredient.css(".ingredient-item").text
        end.text.tr("\t", "").tr("\n","")
    end

    def directions
        doc.css(".direction-lists").each do |direction|
            direction.css(".li")
        end.text.tr("\t","").tr("\n","") 
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