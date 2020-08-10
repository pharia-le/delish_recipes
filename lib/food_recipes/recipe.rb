class FoodRecipes::Recipe

    attr_accessor :name, :type, :url, :yields, :prep, :total, :ingredients, :directions, :author_info
    @@all = []

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
                directions << item.strip.gsub("\r\n", " ")
            end
        end
        directions
    end

    def author_info
        @author_info ||= [doc.css(".author-name").map(&:text)[1],doc.css(".author-bio").text]
        @author_info = ["N/A", "N/A"] if doc.css(".author-name").map(&:text)[1].nil?
        @author_info
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