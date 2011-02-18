Feature: Transforms

  If you see certain phrases repeated over and over in your step definitions, you can
  use transforms to factor out that duplication, and make your step definitions simpler.
  
  Scenario: Named Transform
    Given a file named "features/foo.feature" with:
      """
      Feature:
        Scenario:
          Given a Person aged 15 with blonde hair
      """
    And a file named "features/step_definitions/steps.rb" with:
      """
      class Person < Struct.new(:age)
        def to_s
          "I am #{age} years old"
        end
      end

      Transform(/a Person aged (\d+)/, :named => 'a person aged <age>') do |age|
        Person.new(age.to_i)
      end
      Given /^#{arg('a person aged <age>')} with blonde hair$/ do |person|
        announce "#{person} and I have blonde hair"
      end
      """
    When I run cucumber "features/foo.feature"
    Then it should pass with:
      """
      I am 15 years old and I have blonde hair
      """
