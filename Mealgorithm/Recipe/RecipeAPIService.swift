//
//  RecipeAPIService.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/21/25.
//

import Foundation

struct RecipeResult: Decodable {
    let results: [RecipeItem]
}

struct RecipeItem: Identifiable, Decodable, Equatable {
    let id: Int
    let title: String
    let image: String

    func asDictionary() -> [String: Any] {
        [
            "id": id,
            "title": title,
            "image": image
        ]
    }

    static func fromDictionary(_ dict: [String: Any]) -> RecipeItem? {
        guard
            let id = dict["id"] as? Int,
            let title = dict["title"] as? String,
            let image = dict["image"] as? String
        else {
            return nil
        }
        return RecipeItem(id: id, title: title, image: image)
    }
}

struct RecipeDetail: Decodable {
    let id: Int
    let title: String
    let image: String
    let servings: Int
    let readyInMinutes: Int
    let instructions: String?
    let extendedIngredients: [Ingredient]
}

struct Ingredient: Decodable {
    let id: Int
    let original: String
}

class RecipeAPIService {
    static let shared = RecipeAPIService()
    private let apiKey = Secrets.spoonacularAPIKey

    // RecipeAPIService.swift
    func fetchRecipes(mealType: String, diet: String, completion: @escaping (Result<[RecipeItem], Error>) -> Void) {
        var urlComponents = URLComponents(string: "https://api.spoonacular.com/recipes/complexSearch")!
        urlComponents.queryItems = [
            URLQueryItem(name: "apiKey", value: apiKey),
            URLQueryItem(name: "number", value: "10"),
            URLQueryItem(name: "type", value: mealType),
            URLQueryItem(name: "diet", value: diet)
        ]

        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) {data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            do {
                let response = try JSONDecoder().decode(
                    RecipeResult.self,
                    from: data!
                )
                completion(.success(response.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchRecipeDetails(recipeId: Int, completion: @escaping (Result<RecipeDetail, Error>) -> Void) {
            let urlString = "https://api.spoonacular.com/recipes/\(recipeId)/information?includeNutrition=false&apiKey=\(apiKey)"
            guard let url = URL(string: urlString) else {
                return completion(.failure(URLError(.badURL)))
            }

            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    return completion(.failure(URLError(.badServerResponse)))
                }

                do {
                    let detail = try JSONDecoder().decode(RecipeDetail.self, from: data)
                    completion(.success(detail))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
}

