N+1 query problem occurs when a query is executed on each result of the previous query, in other words, when an application gets data from the database and then loop through the result of that data.

# models/users.rb
    class User < ApplicationRecord
        has_many :comments
    end
  
# models/recipes.rb
    class Recipe < ApplicationRecord
        has_many :comments
    end
    
# models/comments.rb
    class Comment < ApplicationRecord
        belongs_to :user
        belongs_to :recipes
    end
                                        
on show page displaying recipe, its comments and comments user name address
                                        
if fetch recipe using this:-

    @recipe = Recipe.find(params[:id])

then result will be

    Started GET "/recipes/1" for ::1 at 2022-11-10 12:28:55 +0530
    Processing by RecipesController#show as HTML Parameters: {"id"=>"1"}
    Recipe Load (1.6ms)  SELECT "recipes".* FROM "recipes" WHERE "recipes"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
    ↳ app/controllers/recipes_controller.rb:59:in `set_recipe'
    Rendering layout layouts/application.html.erb
    Rendering recipes/show.html.erb within layouts/application
                                            
    Comment Load (2.7ms)  SELECT "comments".* FROM "comments" WHERE "comments"."recipe_id" = $1  [["recipe_id", 1]]
    ↳ app/views/recipes/show.html.erb:39                                      
    User Load (2.5ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 2], ["LIMIT", 1]]
    ↳ app/views/comments/_comment.html.erb:9                                        
    CACHE User Load (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 2], ["LIMIT", 1]]
    ↳ app/views/comments/_comment.html.erb:9                                     
    User Load (2.3ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
    ↳ app/views/comments/_comment.html.erb:9                                     
    Rendered collection of comments/_comment.html.erb [3 times] (Duration: 24.5ms | Allocations: 6821)
    User Load (2.4ms)  SELECT "users".* FROM "users"

here you can see one query is fired for recipe and another 3 to gets its comments and users                                   
and now fetch data for reducing N+1

    @recipe = Recipe.includes(comments: %i[user]).find(params[:id]) # For N+1 query

then result is

    Processing by RecipesController#show as HTML
    Parameters: {"id"=>"1"}

    Recipe Load (1.2ms)  SELECT "recipes".* FROM "recipes" WHERE "recipes"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
    ↳ app/controllers/recipes_controller.rb:60:in `set_recipe'

    Comment Load (1.6ms)  SELECT "comments".* FROM "comments" WHERE "comments"."recipe_id" = $1  [["recipe_id", 1]]
    ↳ app/controllers/recipes_controller.rb:60:in `set_recipe'

    User Load (2.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" IN ($1, $2)  [["id", 2], ["id", 1]]
    ↳ app/controllers/recipes_controller.rb:60:in `set_recipe'
                                            
 which is reduced to 3 queries only                                    
                                        
                                        