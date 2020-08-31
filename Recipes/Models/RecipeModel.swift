struct RecipeModel: Codable {
    var title: String?
    var id: Int?
    var image: String?
    var readyInMinutes: Int?
    var nutrition: Nutrition?
}

struct RecipeArray: Codable {
    var recipes: [RecipeModel]?
}

struct SearchModel: Codable {
    var results: [RecipeModel]?
}

struct Nutrition: Codable {
    var nutrients: [Nutrient]?
}

struct Nutrient: Codable {
    var title: String?
    var amount: Double?
    var unit: String?
}
