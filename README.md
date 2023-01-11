# README

## Versions
- Ruby: 2.7.6

## Specific Libraries
For XML parsing I use SAX parser from the `libxml-ruby` gem because it shows much better performance 
on huge XML files (like product lists for example) than more standard XML parsers such Nokogiri for 
example. This library use system `Libxml2` toolkit and may ask for some system libraries to install. 
Full documentation you can find here:
https://xml4r.github.io/libxml-ruby/index.html

## To run the app:
To run application:

```ruby
bundle install
bin/assignment
```

## Design of the application
All the components of the app are living in the `lib` folder. Most of them use `DependencyInjection` 
principle to have more flexibility and maintainability.  
- `XmlItemsProcessor` - orchestration for other components that combines everything together
- `XmlParser` - running parsing for specific file
- `BatchItemsCallbacks` - callbacks for the `SAX` parser, contains collecting of separate items 
and sending them to the `handler`
- `ItemsHandler` - collecting batches of items and sending them to `batch_service` (used as `handler` for parsing)
- `ExternalService` - mock for processing batch of items (used as `batch_service` in handler)

## Tests
To run tests:

`bundle exec rspec spec`
