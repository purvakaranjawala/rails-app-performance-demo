**Caching in general means that storing the result of some code** so that we can quickly retrieve it later. This allows us to, for example, avoid hitting the database over and over to get data that rarely changes like HomePage will be same for everyone.
Although the general concept is the same for all types of caching,
Rails provide some different techniques of caching: **page, action, fragment, model and HTTP caching**.
You can choose as per your project demands.

Caching is disabled by default in rails development environment, so you will need to turn it on by following command:-
> $ rake dev:cache

Running this command will creates **caching-dev.txt** file inside the tmp directory.
and you can see the code snippet added in your **development.rb** file

![Screenshot from 2022-11-14 12-09-46](https://user-images.githubusercontent.com/116082151/201592189-a569a10b-d901-4437-aa47-cd9114f42d52.png)

To Off🔘 cache in development again run same above command to toggle it off.

**Page Caching**:-

Within this technique, The whole HTML page is saved to a file inside the public directory📁. On subsequent requests, this file is being sent directly to the user without the need to render the view and layout again.
When this technique is not a great choice:
1. If you have many pages that look different for different users.
2. Also, When your website may be accessed by authorised users only.
However, it is better choice for semi-static pages.

From Rails 4, page caching has been extracted to a separate gem i.e. `gem 'actionpack-page_caching'`

**Action Caching**:->

In rails, filters are majorly used for performing some actions prior or later to all actions. Page caching cannot be used if rails uses filters. That is where action caching comes in. 
Its works similar as page caching, however instead of immediately sending the page stored inside the public directory, here Rails stack gets hit. By doing this, it runs before actions that can, for example, handle authentication logic. Gem is:-> 
`gem 'actionpack-action_caching'`

**Fragment Caching**:-

Fragment Caching allows a fragment(or parts) of view logic to be wrapped in a cache block and served out of the cache store when the next request comes in. This is the default caching rails uses.

without applying cache

![Screenshot from 2022-11-14 15-13-07](https://user-images.githubusercontent.com/116082151/201627379-4462bf32-fcca-4ebf-8b42-466ba3a978ee.png)

The majority of load time gets used up in rendering views. you might have often see:--

    Started GET "/" for ::1 at 2022-11-11 13:12:10 +0530
    ActiveRecord::SchemaMigration Pluck (1.4ms)  SELECT "schema_migrations"."version" FROM "schema_migrations" ORDER BY "schema_migrations"."version" ASC
    Processing by RecipesController#index as HTML
    Rendering layout layouts/application.html.erb
    Rendering recipes/index.html.erb within layouts/application
    Recipe Load (2.1ms)  SELECT "recipes".* FROM "recipes"
    ↳ app/views/recipes/index.html.erb:5
    Rendered recipes/_recipe.html.erb (Duration: 1.7ms | Allocations: 632)
    Rendered recipes/_recipe.html.erb (Duration: 0.2ms | Allocations: 94)
    Rendered recipes/_recipe.html.erb (Duration: 0.2ms | Allocations: 94)
    Rendered recipes/_recipe.html.erb (Duration: 0.2ms | Allocations: 94)
    Rendered recipes/index.html.erb within layouts/application (Duration: 38.0ms | Allocations: 9099)
    Rendered layout layouts/application.html.erb (Duration: 106.5ms | Allocations: 48305)
    Completed 200 OK in 153ms (Views: 94.5ms | ActiveRecord: 15.3ms | Allocations: 54230)

You can notice above how many times a partial is loaded for displaying list of recipes.
Notice last line time 153ms where Views time is max.

**Add Caching to partial in index.html.erb**

![Screenshot from 2022-11-14 15-12-40](https://user-images.githubusercontent.com/116082151/201628033-ac24c12e-0dfe-4862-88a6-e5376bbb1e8c.png)

You will see lines in logs something similar to this:

![Screenshot from 2022-11-14 15-17-45](https://user-images.githubusercontent.com/116082151/201628676-d2ebc312-53f8-4d9d-8ec0-c983ab8134f9.png)

You can go further and apply caching technique called **Russian doll caching:**
        
![Screenshot from 2022-11-14 15-37-13](https://user-images.githubusercontent.com/116082151/201632932-4ba04297-8e82-4875-8642-dfb25c55326d.png)

When an object is passed to the _`cache`_ method, it takes its id automatically, append a timestamp and generate a proper cache key (which is an MD5 hash). The cache will automatically expire if the product was updated.

**Model Caching or Low level Caching:-**

This technique is often used when any particular query is hit. This functionality is a part of Rails’ core so no external gem needs to be added. `Rails.cache.fetch` method is mostly used for this caching. This method does both reading and writing to the cache. `fetch` method takes first argument as a storage name. It also has `read` and `write` method. I recommend to go through blog [HoneyBadger](https://www.honeybadger.io/blog/rails-low-level-caching/) for deep info about this technique.
          
![Screenshot from 2022-11-14 19-14-23](https://user-images.githubusercontent.com/116082151/201675557-945f819c-e67c-4982-a428-1e8efc019777.png)

**HTTP Caching or Conditional GET Support**:

The last type is HTTP caching that relies on **HTTP_IF_NONE_MATCH** and **HTTP_IF_MODIFIED_SINCE** headers. Basically, these headers are being sent by the client to check when the page’s content was last modified and whether its unique id has changed. This unique id is called an **ETag** and is generated by the server.

The client receives an `ETag` and sends it inside the **HTTP_IF_NONE_MATCH** header on subsequent requests. If the `ETag` sent by the client does not match the one generated on the server, it means the page has been modified and needs to be downloaded again. Otherwise, a 304 (“not modified”) status code is returned and a browser uses a cached copy of the page. To learn more, checkout references below

There are two methods that can be used to implement HTTP caching: `stale?` and `fresh_when`. Suppose we want to cache a show page
 
![Screenshot from 2022-11-15 12-28-25](https://user-images.githubusercontent.com/116082151/201851244-44ba4b7f-bab6-49ad-b39d-8424378a7670.png)
![Screenshot from 2022-11-15 12-29-30](https://user-images.githubusercontent.com/116082151/201851546-0eb31732-b090-4d47-b795-92fe644e1090.png)

See Response in terminal:--

![Screenshot from 2022-11-15 11-14-12](https://user-images.githubusercontent.com/116082151/201850699-011752c8-7e81-44e9-8253-e77b4b39a31f.png)


**Performance Impact:->**

Be careful while using cache, because it may decrease your application performance if not used intelligently.
Net cache impact = (benefit from hit x hit rate) – (cost of miss x miss rate)
Cost of a `cache miss`(A cache miss is an event in which a system or application makes a request to retrieve data from a cache, but that specific data is not currently in cache memory) penalty is always the number of times of `cache-hit`(A "cache hit" occurs when a file is requested from a cache and the cache is able to fulfill that request) time,
So more frequent cache miss may reduce the application performance significantly instead of improving it.

**Points to Remember:**
1. Cache fragment with a low hit rate that is also quick to render on a miss might be better off not being cached at all. The costs of all of the misses outweigh the benefits of a hit.
2. A template that is extremely slow to render might still benefit on net even if only 10% of cache requests are successful. For reference I recommend  [The performance impact of 'Russian doll'](http://signalvnoise.com/posts/3690-the-performance-impact-of-russian-doll-caching) caching post by Noah Lorang - data analyst for Basecamp


References:

* [Rails Guides](https://guides.rubyonrails.org/caching_with_rails.html#conditional-get-support)​
* [View Caching](https://www.honeybadger.io/blog/ruby-rails-view-caching/)
* [How to improve rails Perfomance using conditional get request by Gavin Morrice](https://sourcediving.com/how-we-improved-our-rails-apps-performance-with-conditional-get-requests-35a7a472a0b9)​, [HTTP Caching](https://web.dev/http-cache/)
* [Mastering low level caching Blog of HoneyBadger](https://www.honeybadger.io/blog/rails-low-level-caching/#authorDetails)

