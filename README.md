# README

This is an application that retrieves weather data from the Weatherbit API and displays it. There is an application layer that caches the API results with Redis for 30 minutes.

This application follows the best practices of enterprise architecture and rails conventions.

- Robust separation of concerns between entities that utilize view models, data acecss adapters, and data proxies.
- Thorough automated unit testing.
- Defensive coding through the use of exception raising and control flow.
- UI that is responsive to application health. the statuses of backing services are bubbled up the user. The user is notified if the data is from the API directly, or from the cache, and the UI components display a "Service down" state.

## Installation

1. Install and run Redis through homebrew.
2. run `bundle install` and `./bin/dev`. This starts both rails and tailwind compilation.

You may need to install tailwind with: `./bin/rails tailwindcss:install`
You may need to install foreman separately, but `./bin/dev` should take care of it.

## General Notes

- The architectural motivation for using Redis:

  - Short collection length: There will only ever be so many zip codes, arond 42,000.
  - In memory: This is the best option, as opposed to database reads and write that likely involved reading from disk, which has more throughput and latency considerations when operating at scale.
  - There is a drawback which would need be considered in a real business scenario - does this business have a need to preserve this data for any length of time beyond its cache expiry?

- Weatherbit API was used (https://www.weatherbit.io/), as it notably ingests zip code, however the dual weatherbit endpoints have given me different cities for the same zipcode. I have opted to use the one for current conditions and display that one. The application is well set up to install a new API service and swap weatherbit out if needed.

  - The application has a form for full address.
  - All form information is passed to the service layer.
  - The API concern is well encapsulated.

## Objects

### View Models

##### Responsibilities

WeatherDay and its child classes, and Locale, transform weather API data into user-friendly formats, including enhanced date and description readability, providing anfor rendering weather data in the UI.

##### Notes

- The responsibility of WeatherDay and it's child view models could be the responsibility of other classes in a larger application. The only thing in this class that is concretely view-specific is the template_path.
  - The methods here could be included from a shared module, as there may be a need for this logic in other views, or in ActiveRecord models should those exist.
  - Some of these methods could also be part of the application's date formatting utility module.
- The intialize methods is validating the presense of data and reassigning is to different variable names. As the application grows, this could be delegated to an api schema definition system that validates API response json, and transforms it for the needs of its consumers.

#### Api::Weatherbit

##### Responsibilities

The Weatherbit class is responsible for interacting with the Weatherbit API, providing methods to make HTTP requests with retries and error handling. It ensures secure access to the API by injecting the API key from environment variables into all queries. Additionally, it centralizes API-specific configurations like base URI, default timeouts, and error handling for consistent and reusable API communication.

##### Notes

- This is an incomplete API adapter that only serves get requests at this point.
- A lot of the functionality here, like the retry method and the error class, belongs in a Base Api class that all API classes would inherit from.

#### Cache

##### Responsibilities

The Cache class is an adapter for Redis, providing a simple interface for setting and retrieving cached data without exposing Redis implementation details to the rest of the application. It also provides a key namespacing system consisting of 3 layers: domain, collection and record.

Notes

- Classes like this are always necessary in an application and so it should be built, it is just an added bonus that it works well as a collaborator to ApiEndpointCache

#### ApiEndpointCache and Endpoint

##### Responsibilities

The ApiEndpointCache class is proxy class that manages data retrieval by combining API calls with a caching mechanism, reducing direct API usage and improving performance. It determines whether to fetch data from the cache or the API, updating the cache when fresh data is retrieved. Additionally, it monitors service availability, gracefully handling errors from both the cache and the API to ensure system reliability.

The Endpoint class exists to define and store data about and api call before it is called, which is not possibly using the Httparty interface directly. It is designed to be a collaborator to the ApiEndPointCache class, though it can be used in other contexts.

#### Service::CurrentWeather and Service::DailyForecast

##### Responsibilities

The CurrentWeather and DailyForecast classes manage the fetching of weather data for a specific location. They interact with the ApiEndpointCache to retrieve data from either the cache or the API. These classes format the data for use in the application and handle cache settings for efficient data retrieval. They also delegate service status and data source information to ApiEndpointCache.

##### Notes

- The application needs a central place to define cache settings like this, such as a central config that is registered and validated, for example checking to see if there are duplicate keys or malformed key fragments.

- These two classes are pretty similar, and this is the least confident part of the code as there are a bit too many responsibilities, but it is not clear what abstractions are required from here. These two classes are still small and simple enough to tolerate duplication. It is not clear to me if the shared logic becomes part of a parent class. The service_up functionality could remain delegated to ApiEndpointCache, or become part of a parent class. Another alternative is to push specificity up a layer to controller, and have one service called instantiated twice with different collaborators.
